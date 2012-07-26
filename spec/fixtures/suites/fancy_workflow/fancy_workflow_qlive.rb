class FancyWorkflowQlive
  include Qlive::Suite
  # include QliveHelper

  def before_each_request(rack_request)
    # login_as Factory(:user)
  end

end