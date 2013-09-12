# -*- encoding: utf-8 -*-

require File.expand_path('../lib/marc/marc4j/version', __FILE__)

Gem::Specification.new do |gem|
  gem.name          = "marc-marc4j"
  gem.version       = Marc::Marc4j::VERSION
  gem.platform      = 'java'
  gem.summary       = %q{convert marc4j and ruby-marc object to/from each other}
  gem.description   = %q{Provides converters (and bundled jar files if you don't already have your own) to convert ruby-marc and marc4j MARC records to/from each other. Works only under jruby)}
  gem.license       = "MIT"
  gem.authors       = ["Bill Dueber"]
  gem.email         = "bill@dueber.com"
  gem.homepage      = "https://github.com/billdueber/ruby-marc-marc4j#readme"

  gem.files         = `git ls-files`.split($/)
  gem.executables   = gem.files.grep(%r{^bin/}).map{ |f| File.basename(f) }
  gem.test_files    = gem.files.grep(%r{^(test|spec|features)/})
  gem.require_paths = ['lib']

  gem.add_dependency "marc", ">= 0.7.1"
  
  gem.add_development_dependency 'bundler', '~> 1.0'
  gem.add_development_dependency 'minitest'
  gem.add_development_dependency 'rake'
  gem.add_development_dependency 'yard'
end
