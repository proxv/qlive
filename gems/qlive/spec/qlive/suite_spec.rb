require File.expand_path("../../spec_helper.rb", __FILE__)

Registry = ::Qlive::Registry

describe Qlive::Suite do
  let(:suite) do
    Registry.find_suites
    res = Registry.build_suite('fancy_workflow/as_user')
    res.prepare # normally called by rack
    res.after_head_open << '<script> doSomethingEarly();</script>'
    res
  end

  it "should provide array of desired html at all insertion points" do
    suite.after_head_open.length.should == 1
    suite.html_after_head_open.should match(/doSomethingEarly/) # it also adds before & after comments
    suite.html_before_body_close.should match(/qunit\.js/)
  end

end


describe Qlive::Suite, "qunit source" do
  before(:each) do
    @suite = Qlive::Registry.build_suite('fancy_workflow/as_user')
    @suite.prepare
  end

  it "should insert qunit resources and all js files in the same directory as the suite" do
    source_tags = @suite.qunit_javascript_test_sources
    source_tags.length.should == 2
    source_tags.join("\n").should match(/#{Regexp.escape("/qlive/sources/fancy_workflow/post-new-recipe.js")}/)
  end

end


describe Qlive::Suite, "insertion helper methods" do
  let(:registration) { Registry.find_suites; Registry.all_by_name['fancy_workflow/as_user'] }

  it "should not mess up metacoding too much" do
    a = registration.klass.new
    b = registration.klass.new
    a.after_head_open = [ 8 ]
    b.after_head_open = [ 9 ]
    a.after_head_open[0].should == 8
    b.after_head_open[0].should == 9
  end
end

