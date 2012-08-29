require 'capybara/rspec'
require 'headless'  # https://github.com/leonid-shevtsov/headless
require 'qlive/matchers'
require "#{Qlive::Engine.root}/app/helpers/qlive/suites_helper.rb"


module Qlive
  module Runner

    module ClassMethods

      def run_qlive
        Qlive::Matchers.add_matchers

        Qlive.setup[:base_path] ||= "#{Rails.root}/spec/qunits"
        Qlive.setup[:logger] ||= Rails.logger
        Qlive::Registry.find_suites

        describe "pages", :type => :request do
          extend Qlive::SuitesHelper

          def visit_qunit_page(suite_name, href)
            using_wait_time(Qlive.setup[:capybara_wait_time]) do  # perhaps let suites override this value
              Qlive.logger.info "Qlive sending capybara to run '#{suite_name}' on #{href}"
              visit href
              page.html.should_not be_nil
              page.wait_until(Qlive.setup[:capybara_wait_time]) do # hmmmm
                page.evaluate_script('!!window.qunitComplete')
              end
              failure_text = page.evaluate_script("$('li.fail li.fail').text();")
              page.should pass_qunit_tests(failure_text)
            end
          end

          Qlive::Registry.suites.values.each do |suite_meta|
            load suite_meta[:path]
            suite = Qlive::Registry.build_suite(suite_meta[:name])
            hrefs_for_suite(suite).each do |href|
              it "should pass qunit tests when visiting: #{href}" do
                visit_qunit_page(suite.name, href)
              end
            end
          end

          before(:all) do
            Qlive.setup[:before_suites].call if Qlive.setup[:before_suites]
            if Qlive.setup[:start_xvfb]
              @headless = ::Headless.new(Qlive.setup[:headless_config])
              @headless.start
            end
          end

          before(:each) do
            page.reset!
          end

          after(:all) do
            puts "\nGetting rough with headless webkit_server. In the event of a fatal IO error, use your judgement regarding calling the police."
            @headless.destroy if @headless
            if Qlive.setup[:after_suites]
              Qlive.setup[:after_suites].call
            end
          end
        end
      end
    end

    def self.included(base)
      base.extend ClassMethods
    end

  end
end

