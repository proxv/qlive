require "qlive-rspec/version"
require "qlive/runner"


module QliveRspec
  Qlive.setup[:start_xvfb] = true unless Qlive.setup.has_key?(:start_xvfb)
  Qlive.setup[:headless_config] = {
    :display => 99
    # :destroy_at_exit => true, :reuse => false
  }
  Qlive.setup[:capybara_wait_time] = 30
end
