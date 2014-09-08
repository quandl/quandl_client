# -*- encoding: utf-8 -*-
$:.push File.expand_path("../lib", __FILE__)
require "quandl/client/version"

Gem::Specification.new do |s|
  s.name        = "quandl_client"
  s.version     = Quandl::Client::VERSION
  s.authors     = ["Blake Hilscher"]
  s.email       = ["blake@hilscher.ca"]
  s.homepage    = "https://www.quandl.com"
  s.license     = "MIT"
  s.summary     = "Client rest orm."
  s.description = "An orm for the cassinatra rest interface."

  s.files         = `git ls-files`.split("\n")
  s.test_files    = `git ls-files -- {test,spec,features}/*`.split("\n")
  s.executables   = `git ls-files -- bin/*`.split("\n").map{ |f| File.basename(f) }
  s.require_paths = ["lib"]

  s.add_runtime_dependency "quandl_data", "~> 1.5"
  s.add_runtime_dependency "activesupport", ">= 3.0.0"
  s.add_runtime_dependency "her", "~> 0.6.0"
  s.add_runtime_dependency 'json', '~> 1.7.7'
  s.add_runtime_dependency "scope_composer", "~> 0.3"

  s.add_development_dependency "rake", "~> 10.0"
  s.add_development_dependency "rspec", "~> 2.13"
  s.add_development_dependency "factory_girl_rails"
  s.add_development_dependency "fivemat", "~> 1.2"
  s.add_development_dependency "pry"
  s.add_development_dependency "guard"
  s.add_development_dependency "guard-rspec"
  s.add_development_dependency "quandl_utility"
end