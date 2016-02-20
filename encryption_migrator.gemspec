# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'encryption_migrator/version'

Gem::Specification.new do |spec|
  spec.name          = "encryption_migrator"
  spec.version       = EncryptionMigrator::VERSION
  spec.authors       = ["Tom Kadwill"]
  spec.email         = ["tomkadwill@gmail.com"]

  spec.summary       = %q{Migration helpers for encryption}
  spec.description   = %q{Add methods to ActiveRecord::Migration that help with encryption}
  spec.homepage      = "http://github.com/tomkadwill/encryption_migrator"
  spec.license       = "MIT"
  spec.files         = `git ls-files -z`.split("\x0").reject { |f| f.match(%r{^(test|spec|features)/}) }
  spec.bindir        = "exe"
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]

  spec.add_development_dependency "bundler", "~> 1.11"
  spec.add_development_dependency "rake", "~> 10.0"
  spec.add_development_dependency "rspec", "~> 3.0"
end
