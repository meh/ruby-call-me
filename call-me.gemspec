Gem::Specification.new {|s|
	s.name         = 'call-me'
	s.version      = '0.0.2.2'
	s.author       = 'meh.'
	s.email        = 'meh@paranoici.org'
	s.homepage     = 'http://github.com/meh/ruby-call-me'
	s.platform     = Gem::Platform::RUBY
	s.summary      = 'Various calling things, overload, pattern matching, memoization and such.'
	s.files        = Dir.glob('lib/**/*.rb')
	s.require_path = 'lib'

	s.add_dependency 'refining'

	s.add_development_dependency 'rake'
	s.add_development_dependency 'rspec'
}
