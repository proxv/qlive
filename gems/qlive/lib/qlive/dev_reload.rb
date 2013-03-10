module Qlive
  class DevReload

    def initialize(app, opts={})
      @app = app
    end

    def call(env)
      self.class.reload_main if env['QUERY_STRING'].include?('qlive=')
      @app.call(env)
    end


    def self.reload_main
      Registry.reset_all
      load "#{File.expand_path('../rack.rb', __FILE__)}"
      load "#{File.expand_path('../qunit_assets.rb', __FILE__)}"
      load "#{File.expand_path('../suite.rb', __FILE__)}"
      load "#{File.expand_path('../registry.rb', __FILE__)}"
      Registry.find_suites
    end
  end
end