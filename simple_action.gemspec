# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'simple_action/version'

Gem::Specification.new do |spec|
  spec.name = 'simple_action'
  spec.version = SimpleAction::VERSION
  spec.authors = ['brycesenz']
  spec.email = ['bryce.senz@gmail.com']
  spec.description = %q{Simple Service Object class for services & API endpoints}
  spec.summary = %q{A DSL for specifying services objects, including parameters and execution}
  spec.homepage = 'https://github.com/brycesenz/simple_action'
  spec.license = 'MIT'

  spec.files = `git ls-files`.split($/)
  spec.executables = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ['lib']

  spec.add_dependency 'simple_params', '>= 2.0.2'
  spec.add_development_dependency 'appraisal'
  spec.add_development_dependency 'bundler', '~> 1.5'
  spec.add_development_dependency 'rake', '~> 10.1'
  spec.add_development_dependency 'rspec', '~> 2.6'
  spec.add_development_dependency 'pry'
end
