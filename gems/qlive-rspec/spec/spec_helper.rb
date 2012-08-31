ENV["RAILS_ENV"] = 'test'
ENV["DUMMY_HOME"] = dummy_home = File.expand_path("../dummy",  __FILE__)
require File.expand_path("#{dummy_home}/config/environment.rb",  __FILE__)
require 'rspec/rails'

Dir["#{dummy_home}/spec/spec_support/**/*.rb"].each {|f| require f}   # I don't care about Windows

RSpec.configure do |config|
  config.use_transactional_fixtures = false
end

Capybara.default_driver = :webkit

