QliveHome = File.expand_path('../..', __FILE__)
require 'rack/mock'
require "#{QliveHome}/lib/qlive"

def fixtures_base_path
  "#{QliveHome}/spec/fixtures"
end


RSpec.configure do |config|
  Qlive.setup[:base_path] = fixtures_base_path

end

