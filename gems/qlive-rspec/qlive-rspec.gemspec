# -*- encoding: utf-8 -*-
require File.expand_path('../lib/qlive-rspec/version', __FILE__)

Gem::Specification.new do |gem|
  gem.authors       = ["ProxV"]
  gem.email         = ["support@proxv.com"]
  gem.summary       = "Run qlive-rails qunit javascript tests headlessly alongside your normal rspec integration examples"
  gem.description   = gem.summary
  gem.homepage      = "https://github.com/proxv/qlive/gems/qlive-rspec/"

  gem.files         = `git ls-files`.split($\)
  gem.executables   = gem.files.grep(%r{^bin/}).map{ |f| File.basename(f) }
  gem.test_files    = gem.files.grep(%r{^(test|spec|features)/})
  gem.name          = "qlive-rspec"
  gem.require_paths = ["lib"]
  gem.version       = QliveRspec::VERSION

  gem.add_dependency "qlive-rails", "~> 0.4.0"
  gem.add_dependency "rspec-rails", "~> 2.11"
  gem.add_dependency "poltergeist" #, "~> 1.1"

  gem.add_development_dependency "factory_girl_rails", "~> 3.5"
end
