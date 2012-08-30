require 'capybara/rspec'
require 'headless'  # https://github.com/leonid-shevtsov/headless
require 'qlive/matchers'
require "#{Qlive::Engine.root}/app/helpers/qlive/suites_helper.rb"


module Qlive
  module Runner

    module ClassMethods

      def run_qlive(args={})
        Qlive::Matchers.add_matchers
        Qlive.setup[:base_path] ||= "#{Rails.root}/spec/qunits"
        Qlive.setup[:logger] ||= Rails.logger

        # todo: support suite selection by allowing directory and path names, not just suite names. (both absolute and relative to base_path)
        desired_suites_by_name = args[:suites] || Qlive::Registry.find_suites.keys
        describe "qlive", :type => :request do
          before(:all) do
            Qlive.setup[:before_suites].call(page) if Qlive.setup[:before_suites]
            if Qlive.setup[:start_xvfb] && Capybara.current_driver == :webkit
              @headless = ::Headless.new(Qlive.setup[:headless_config])
              @headless.start
            end
          end

          desired_suites_by_name.each do |desired_suite|
            suite = resolve_suite(desired_suite)
            raise "Could not find qlive suite for: #{desired_suite}" unless suite
            describe "suite '#{suite.name}'" do
              extend Qlive::SuitesHelper

              def visit_qunit_page(suite_name, href)
                using_wait_time(Qlive.setup[:capybara_wait_time]) do  # perhaps let individual suites override this value
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


              before(:each) do
                args[:before_each].call(page) if args[:before_each]
                page.reset!
              end

              hrefs_for_suite(suite).each do |href|
                it "should pass qunit tests when visiting: #{href}" do
                  visit_qunit_page(suite.name, href)
                end
              end

              after(:each) do
                args[:after_each].call(page) if args[:after_each]
              end
            end
          end

          after(:all) do
            Qlive.setup[:after_suites].call(page) if Qlive.setup[:after_suites]
            if @headless
              puts "\nGetting rough with headless webkit_server. In the event of a fatal IO error, use your judgement regarding calling the police."
              @headless.destroy
            end
          end

        end
      end

      def resolve_suite(desired_suite)
        #todo: if it ends in .rb, check for the file, and use the path to get the suite
        Qlive::Registry.build_suite(desired_suite)
      end
    end

    def self.included(base)
      base.extend ClassMethods
    end

  end
end

