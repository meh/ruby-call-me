#! /usr/bin/env ruby
require 'rake'

task :default => :test

task :test do
	Dir.chdir 'test'

	sh 'rspec memoize_spec.rb --color --format doc'
	sh 'rspec named_spec.rb --color --format doc'
	sh 'rspec overload_spec.rb --color --format doc'
	sh 'rspec pattern-matching_spec.rb --color --format doc'
end
