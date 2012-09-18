require './pwgen'

describe PwGen do
  it 'should have sensible defaults' do
    PwGen::DefaultLen.should == 32
    PwGen::Lowercase.uniq.length.should == 26
    PwGen::Uppercase.uniq.length.should == 26
    PwGen::Numbers.uniq.length.should == 10
    PwGen::Symbols.uniq.length.should == 30
    PwGen.new.all_chars.length.should == 92
  end

  it 'should raise on bogus length value' do
    [nil, 'abc'].each do |value|
      lambda{PwGen.new value}.should raise_error(PwGen::NotNumericError)  
    end
  end

  it 'should raise on an unsuitable default value' do
    [-1, 0, 3, 5, 257, 400000].each do |value|
      lambda{PwGen.new value}.should raise_error(PwGen::LengthError)  
    end
  end

  it 'should create the object with the appropriate length value' do
    PwGen.new.length.should == 32
    PwGen.new(200).length.should == 200
  end

  it 'should create the password with the appropriate length' do
    test_obj = PwGen.new
    test_obj.pw.length.should == PwGen::DefaultLen
    test_obj = PwGen.new 50
    test_obj.pw.length.should == 50
  end

  it 'should give a reasonable distribution among all tokens' do
    COUNT = 100000
    test_obj = PwGen.new
    dict = Hash.new(0)
    COUNT.times do
      val = test_obj.send(:_next)
      dict[val] += 1
    end

    equal = COUNT / dict.length
    CONF = 0.9
    dict.each do |key, value|
      # Currently I'm checking each value does not differ from count by more than 10%.
      # TODO: make this more statistically rigorous, with actual confidence intervals.
      value.should be >= equal * CONF
      value.should be <= equal / CONF
    end
  end
end
