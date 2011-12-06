#! /usr/bin/env ruby
require 'rake'

task :default => :test

task :test do
	Dir.chdir 'test'

	sh 'rspec memoize_spec.rb --color --format doc'
	sh 'rspec named_spec.rb --color --format doc'
end
