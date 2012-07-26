require File.expand_path("../../spec_helper.rb", __FILE__)

describe Qlive::Rack do
  class HappyGoLuckyQlive
    include Qlive::Suite

    def before_each_request(rack_request)
      rack_request.session[:logged_in_as] = 1255
    end
  end

  before(:each) do
    suite = HappyGoLuckyQlive.new
    Qlive::Registry.stub!(:build_suite).and_return suite
  end

  let(:environment) { Rack::MockRequest.env_for('/webapp/tinfoiled?qlive=happy_go_lucky#frontpage') }
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
    environment['rack.session'].should == {:logged_in_as => 1255} # see before_each_request
  end

  #todo: describe "magic param" do
  #  it "should do nothing when magic param is missing"
  #  it "should permit configuration of magic_param to use a query param other than 'qlive'"
  #end


  def html_page
    <<-END.gsub(/^\s+/, '')
      <html><head>
      <title>Why Jasmine Is Annoying</title>
      <script src='/app-ui.js'></script>
      </head>
      <body class="webapp">
      <div class="app-content-holder"></div>
      </body></html>
    END
  end

end