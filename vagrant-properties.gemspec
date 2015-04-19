# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'vagrant-properties/version'

Gem::Specification.new do |spec|
  spec.name          = 'vagrant-properties'
  spec.version       = VagrantProperties::VERSION
  spec.authors       = ['linyows']
  spec.email         = ['linyows@gmail.com']
  spec.summary       = %q{Mnagement multiple machines.}
  spec.description   = %q{Mnagement multiple machines.}
  spec.homepage      = 'https://github.com/linyows/vagrant-properties'
  spec.license       = 'MIT'

  spec.files         = `git ls-files -z`.split("\x0")
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ['lib']

  spec.add_development_dependency 'bundler', '~> 1.7'
  spec.add_development_dependency 'rake', '~> 10.0'
end
