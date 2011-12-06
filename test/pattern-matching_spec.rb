#! /usr/bin/env ruby
require 'rubygems'
require 'call-me/pattern-matching'

class LOL
  def_pattern 0
  def factorial (n)
    1
  end

  def factorial (n)
    n * factorial(n - 1)
  end
end

describe 'pattern-matching' do
	it 'should work properly' do
		LOL.new.factorial(4).should == 24
	end
end
