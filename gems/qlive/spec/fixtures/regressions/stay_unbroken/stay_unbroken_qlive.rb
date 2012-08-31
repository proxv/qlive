module Regressions
  class StayUnbrokenQlive
    include Qlive::Suite

    def before_each_request(rack_request)
      # fixtures that reproduce the original bug
    end

  end
end