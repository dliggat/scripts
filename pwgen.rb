#!/usr/bin/ruby

require 'securerandom'

class PwGen
  class LengthError < ArgumentError; end
  attr_reader :length 


  Lowercase = ('a'..'z').to_a
  Uppercase = ('A'..'Z').to_a
  Numbers = (0..9).to_a
  Symbols = %w(! @ # $ % ^ & * ( ) - _ = + [ { ] } \ | ; : ' " < , > . ? /)
  AllChars = Lowercase + Uppercase + Numbers + Symbols
  DefaultLen = 20
  ValidLengthRange = (6..256)

  def initialize(length=DefaultLen)
    unless ValidLengthRange.include? length
      raise(LengthError, 'Length must be within the range %s' % ValidLengthRange.to_s)
    end
    @length = length
  end

  def _next
    all_chars[SecureRandom.random_number all_chars.length]
  end

  def all_chars
    Lowercase + Uppercase + Numbers + Symbols
  end

  def pw
    result = Array.new
    @length.times do 
      result << _next
    end
    result.to_s
  end
end


def main
  p = PwGen.new
  puts p.pw
end


if __FILE__ == $0
  main
end
