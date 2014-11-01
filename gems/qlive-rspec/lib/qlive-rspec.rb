require "qlive-rspec/version"
require "qlive/runner"


module QliveRspec
  Qlive.setup[:capybara_wait_time] ||= 30
end
