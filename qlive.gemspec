# -*- encoding: utf-8 -*-
$:.push File.expand_path("../lib", __FILE__)
require "qlive/version"

Gem::Specification.new do |s|
  s.name        = "qlive"
  s.version     = Qlive::VERSION
  s.authors     = ["ProxV"]
  s.email       = ["support@proxv.com"]
  s.homepage    = ""
  s.summary     = "run qunit tests against actual back-end server with prepared test fixtures"
  s.description = ""

  s.rubyforge_project = "qlive"

  s.files         = `git ls-files`.split("\n")
  s.test_files    = `git ls-files -- {test,spec,features}/*`.split("\n")
  s.executables   = `git ls-files -- bin/*`.split("\n").map{ |f| File.basename(f) }
  s.require_paths = ["lib"]

  s.add_dependency 'rack', '~> 1.4'
  s.add_development_dependency "rspec", '~> 2.8.0'
end
