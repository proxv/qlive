require File.expand_path("../../spec_helper.rb", __FILE__)

describe Qlive::Suite do
  class BlueSuite
    include Qlive::Suite

    def before_each_request(rack_request)
      @pretend_factory_girl = true
      @pretend_devise_user_login = true
    end
  end

  let(:suite) do
    suite = BlueSuite.new
    suite.prepare
    suite.after_head_open << '<script> doSomethingEarly();</script>'
    suite
  end

  it "should provide array of desired html at all insertion points" do
    suite.after_head_open.length.should == 1
    suite.html_after_head_open.should match(/doSomethingEarly/) # it also adds before & after comments
    suite.html_before_body_close.should match(/qunit\.js/)
  end

end


describe Qlive::Suite, "qunit source" do
  before(:each) do
    @suite = Qlive::Registry.build_suite('fancy_workflow')
    @suite.prepare
  end

  it "should insert qunit resources and all js files in the same directory as the suite" do
    source_tags = @suite.qunit_javascript_test_sources
    source_tags.length.should == 2
    source_tags.join("\n").should match(/#{Regexp.escape("/qlive/sources/fancy_workflow/post-new-recipe.js")}/)
  end

end


describe Qlive::Suite, "insertion helper methods" do
  class GreenSuite
    include Qlive::Suite
  end

  let(:suite) { GreenSuite.new }

  it "should not mess up metacoding too much" do
    a = GreenSuite.new
    b = GreenSuite.new
    a.after_head_open = [ 8 ]
    b.after_head_open = [ 9 ]
    a.after_head_open[0].should == 8
    b.after_head_open[0].should == 9
  end
end

