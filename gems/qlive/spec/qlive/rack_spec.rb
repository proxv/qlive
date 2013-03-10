require File.expand_path("../../spec_helper.rb", __FILE__)

Registry = Qlive::Registry

describe Qlive::Rack do

  before(:each) do
    Registry.find_suites
    suite = FancyWorkflow::AsUser.new
    class << suite
      def before_each_suite(rack_request)
        rack_request.session[:logged_in_as] = 1255
      end
    end
    Registry.stub!(:build_suite).with('fancy_workflow/as_user').and_return(suite)
  end

  let(:environment) { Rack::MockRequest.env_for('/webapp/tinfoiled?qlive=fancy_workflow/as_user#frontpage') }
  let(:application) { lambda{|env| [200, {'Content-Type' => 'text/html'}, [ html_page ]]} }
  let(:middleware) do
    Qlive::Rack.new(application, { :base_path => fixtures_base_path })
  end

  it "should insert qunit test resources when magic_param is present in query string" do
    body = middleware.call(environment)[2].join('')
    body.should match(/qunit\.js/)
  end

  it "should allow suite to modify session data" do
    middleware.call(environment)
    environment['rack.session'].should == {:logged_in_as => 1255} # see before_each_suite
  end

  #todo: describe "magic param" do
  #  it "should do nothing when magic param is missing"
  #  it "should permit configuration of magic_param to use a query param other than 'qlive'"
  #end


  def html_page
    <<-END.gsub(/^\s+/, '')
      <html><head>
      <title>Why Fixturing Is Annoying</title>
      <script src='/app-ui.js'></script>
      </head>
      <body class="webapp">
      <div class="app-content-holder"></div>
      </body></html>
    END
  end

end