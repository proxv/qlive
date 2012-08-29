$:.push File.expand_path("../lib", __FILE__)

require "qlive-rails/version"

Gem::Specification.new do |gem|
  gem.name        = "qlive-rails"
  gem.version     = QliveRails::VERSION
  gem.authors     = ["ProxV"]
  gem.email       = ["support@proxv.com"]
  gem.homepage    = "https://github.com/proxv/qlive-rails/"
  gem.summary     = "Ruby on Rails engine for running qunit javascript tests using server-side factories and user login"
  gem.description = gem.summary

  gem.files = Dir["{app,config,db,lib,public}/**/*"] + ["Rakefile", "README.md"]
  gem.test_files = Dir["test/**/*"]

  gem.add_dependency "qlive", '~> 0.1.1'
  gem.add_dependency "rails", "~> 3.2"
  gem.add_dependency 'haml-rails'
  gem.add_dependency 'sass-rails'
  gem.add_development_dependency "rspec-rails", "~> 2.8.0"
  gem.add_development_dependency "factory_girl_rails", "~> 3.5.0"

end
