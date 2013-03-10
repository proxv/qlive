module FancyWorkflow
  class AsAdmin
    include Qlive::Suite
    # would normally include QliveHelper

    def before_each_suite(rack_request)
      # would login_as Factory(:admin)
    end

  end
end
