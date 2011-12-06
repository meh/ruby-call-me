#! /usr/bin/env ruby
require 'rubygems'
require 'call-me/named'

class LOL
	singleton_named :a, :b, :optional => [:b]
	def self.omg (a, b = nil)
		[a, b]
	end

	named def lol (a, b)
		[a, b]
	end

	named :a, :b, :optional => [:b]
	def wat (a, b)
		[a, b]
	end

	named def omg (&block)
		block
	end
end

describe 'named' do
	it 'works with explicit class notification' do
		LOL.omg(2, 3).should == LOL.omg(:a => 2, :b => 3)
	end

	unless RUBY_VERSION.start_with?('1.8')
		it 'works with explicit namedification' do
			LOL.new.wat(:a => 2, :b => 3).should == LOL.new.wat(2, 3)
		end

		it 'works with auto namedification' do
			LOL.new.lol(:a => 2, :b => 3).should == LOL.new.lol(2, 3)
		end

		it 'works passes the block correctly' do
			LOL.new.omg {}.should_not == nil
		end
	end
end
