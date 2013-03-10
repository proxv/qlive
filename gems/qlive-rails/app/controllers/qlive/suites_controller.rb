module Qlive
  class SuitesController < ActionController::Base

    def index
      Qlive::DevReload.reload_main if Qlive.setup[:gem_dev_mode]
      Qlive::Registry.find_suites
      @suites = Qlive::Registry.all_by_name.keys.map do |suite_name|
        Qlive::Registry.build_suite(suite_name)
      end
    end


  end
end
