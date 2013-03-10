require 'capybara/rspec'
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
        describe "qlive", :type => :feature do
          before(:all) do
            Qlive.setup[:before_suites].call if Qlive.setup[:before_suites]
           end

          desired_suites_by_name.each_with_index do |desired_suite, ndx|
            suite = resolve_suite(desired_suite)
            raise "Could not find qlive suite for: #{desired_suite}" unless suite

            describe "suite ##{ndx + 1} '#{suite.suite_name}'" do
              extend Qlive::SuitesHelper

              def visit_qunit_page(suite, href)
                using_wait_time(Qlive.setup[:capybara_wait_time]) do  # perhaps let individual suites override this value
                  Qlive.logger.info "Qlive sending capybara to run '#{suite.suite_name}' on #{href}"
                  visit href
                  page.html.should_not be_nil
                  page.find("#qlive-complete")
                  failure_text = page.evaluate_script("$('li.fail li.fail').text();")
                  page.should pass_qunit_tests(suite, failure_text)
                end
              end


              before(:each) do
                args[:before_each].call if args[:before_each]
                page.reset!
              end

              hrefs_for_suite(suite).each do |href|
                it "should pass qunit tests when visiting: #{href}" do
                  visit_qunit_page(suite, href)
                end
              end

              after(:each) do
                args[:after_each].call(example) if args[:after_each]
              end
            end
          end

          after(:all) do
            Qlive.setup[:after_suites].call if Qlive.setup[:after_suites]
          end
        end
      end

      def resolve_suite(desired_suite)
        Qlive::Registry.build_suite(desired_suite)
      end
    end

    def self.included(base)
      base.extend ClassMethods
    end

  end
end

