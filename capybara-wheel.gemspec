# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'capybara/wheel/version'

Gem::Specification.new do |spec|
  spec.name          = "capybara-wheel"
  spec.version       = Capybara::Wheel::VERSION
  spec.authors       = ["@gabrielrotbart"]
  spec.email         = ["gabe@hooroo.com"]
  spec.description   = %q{Keeping the rodent on track}
  spec.summary       = %q{Creating (yet another) page model gem based around making capybara tests more stable with no need for waits}
  spec.homepage      = ""
  spec.license       = "MIT"

  spec.files         = `git ls-files`.split($/)
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ["lib"]

  spec.add_development_dependency "bundler", "~> 1.3"
  spec.add_development_dependency "rake"
  spec.add_development_dependency "rspec"
  spec.add_development_dependency "selenium-webdriver", "~> 2.0"
  spec.add_development_dependency "sinatra", "~> 1.0"
  spec.add_development_dependency "pry"

  spec.add_dependency "capybara", "~> 2.1"
  spec.add_dependency "rspec"
end
