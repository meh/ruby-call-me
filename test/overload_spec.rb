#! /usr/bin/env ruby
require 'rubygems'
require 'call-me/overload'

class LOL
  def_signature Integer
  def lol (a)
    a * 2
  end

  def_signature String
  def lol (str)
    str * 2
  end
end

class OMG < LOL
	def lol (*args)
		super(*args) rescue args
	end
end

describe 'overload' do
	it 'should find the right body to call' do
		LOL.new.lol(2).should == 4
		LOL.new.lol(?a).should == 'aa'
	end

	it 'should properly raise when not matching signatures' do
		expect {
			LOL.new.lol
		}.should raise_error
	end

	it 'should be overridden properly in subclasses' do
		OMG.new.lol(1, 2).should == [1, 2]
		OMG.new.lol(2).should == 4
	end
end
