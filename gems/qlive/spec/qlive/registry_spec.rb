require File.expand_path("../../spec_helper.rb", __FILE__)

describe Qlive::Registry, "find_suites" do
  it "should find qlive suites in the qlive base_path" do
    suites = Qlive::Registry.find_suites
    suites.length.should > 0
  end

  it "should name suites by pathname within the base path, trimming qlive.rb and lead/trail slashes" do
    suites = Qlive::Registry.find_suites
    suites['fancy_workflow/as_user'].should_not be_nil
    suites['fancy_workflow/as_admin'].should_not be_nil
    suites['regressions/stay_unbroken'].should_not be_nil
  end
end


describe Qlive::Registry, "build_suite" do

  it "should instantiate suite and add class to meta data registry" do
    suite = Qlive::Registry.build_suite('fancy_workflow/as_user')
    suite.class.name.should == 'FancyWorkflow::AsUser'
  end

  it "should raise an error when suite is not found" do
    lambda {
      suite = Qlive::Registry.build_suite('stay_unbroken')
    }.should raise_error
  end

end
