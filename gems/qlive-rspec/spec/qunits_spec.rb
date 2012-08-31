require_relative './spec_helper.rb'

include Qlive::Runner

describe "qunits" do
  run_qlive(:before_each => lambda {
    # I can do things here like set ENV variables for sauce
  })

end
