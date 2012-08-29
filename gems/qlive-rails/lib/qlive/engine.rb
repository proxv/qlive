require 'qlive/rack'
require 'qlive/dev_reload'
require 'qlive/suite'

module Qlive
  class Engine < Rails::Engine

    initializer "qlive" do |app|
      Qlive.setup[:base_path] ||= "#{Rails.root}/spec/qunits"
      Qlive.setup[:logger] ||= Rails.logger
      Qlive.logger.warn "Mounting Qlive::Rack to enable qunit testing against server's backend. (Do not use this on production systems.)"
      if Qlive.setup[:hand_mounted]
        Qlive.setup[:hand_mounted].call
      else
        app.middleware.insert_after(::ActionDispatch::ParamsParser, Qlive::Rack, {
          :base_path => Qlive.setup[:base_path]
        })

        if Rails.configuration.serve_static_assets
          app.middleware.insert_after ::ActionDispatch::Static, ::ActionDispatch::Static, "#{root}/public"
        end
      end

      if Qlive.setup[:gem_dev_mode]
        app.middleware.insert_before(::ActionDispatch::ParamsParser, Qlive::DevReload)
      end
    end

  end
end
