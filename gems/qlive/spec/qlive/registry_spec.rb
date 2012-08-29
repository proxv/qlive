require File.expand_path("../../spec_helper.rb", __FILE__)

describe Qlive::Registry, "find_suites" do
  it "should find qlive suites" do
    suites = Qlive::Registry.find_suites
    suites.length.should > 0
    suites['fancy_workflow'].should_not be_nil
  end

  it "should support subdirectories namespaced by modules" do
    suites = Qlive::Registry.find_suites
    suites.length.should == 2
    suites['regressions/stay_unbroken'].should_not be_nil
  end
end


describe Qlive::Registry, "build_suite" do

  it "should instantiate suite and add class to meta data registry" do
    suite = Qlive::Registry.build_suite('fancy_workflow')
    suite.class.name.should == 'FancyWorkflowQlive'
  end

  it "should work with namespaced subdirs " do
    suite = Qlive::Registry.build_suite('regressions/stay_unbroken')
    suite.class.name.should == 'Regressions::StayUnbrokenQlive'
  end

end
