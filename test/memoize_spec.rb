#! /usr/bin/env ruby
require 'rubygems'
require 'call-me/memoize'

class LOL
	singleton_memoize
	def self.ruby_version
		`ruby -v`
	end

	singleton_memoize
	def self.add (a, b)
		a + b
	end

	memoize
	def ruby_version
		`ruby -v`
	end

	memoize
	def add (a, b)
		a + b
	end
end

describe 'memoize' do
	let(:test) do
		LOL.new
	end

	describe 'singleton' do
		it 'correctly caches methods with no argument' do
			LOL.ruby_version

			LOL.memoize_cache[:ruby_version][nil][0].should === LOL.ruby_version
		end

		it 'correctly cache methods with arguments' do
			LOL.add(2, 2).should == 4

			LOL.memoize_cache[:add][[2, 2]][0].should === 4
		end
	end

	describe 'instance' do
		it 'correctly caches methods with no argument' do
			test.ruby_version

			test.memoize_cache[:ruby_version][nil][0].should === test.ruby_version
		end

		it 'correctly cache methods with arguments' do
			test.add(2, 2).should == 4

			test.memoize_cache[:add][[2, 2]][0].should == 4
		end
	end
end
