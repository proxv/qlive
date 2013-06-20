require_relative './spec_helper.rb'
require_relative '../lib/qlive-rspec'

RSpec.configure do |c|
  $methods_called_in_SkipThisQlive = []
  c.filter_run_excluding :very_redundant => true
end

include Qlive::Runner


describe "qunits" do
  run_qlive(:before_each => lambda {
    # I can do things here like set ENV variables for sauce
  })
end


describe "filter tags" do
  it "should skip excluded tags" do    
    # set in spec/dummy/spec/qunits/adding_todos/skip_this_qlive.rb. Better way to test?
    $methods_called_in_SkipThisQlive.should include(:rspec_tags)
    $methods_called_in_SkipThisQlive.should_not include(:before_each_suite)     
  end
end