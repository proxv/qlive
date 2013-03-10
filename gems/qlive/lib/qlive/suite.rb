require 'qlive/setup'
require 'qlive/qunit_assets'

module Qlive
  module Suite
    include QunitAssets

    attr_reader :request, :session

    InsertionPoints ||= [ 'after_head_open', 'before_head_close', 'after_body_open', 'before_body_close']

    def self.included(base)
      registration = Registry.register_class(base)
      base.class_eval do
        class << self
          attr_reader :suite_registration
        end
      end
      base.instance_variable_set(:@suite_registration, registration)

      InsertionPoints.each do |place|
        attr_accessor place

        define_method "html_#{place}" do
          htmls = instance_variable_get("@#{place}")
          has_content = htmls.length > 0
          htmls.unshift "\n<!-- Begin Qlive Insertions (#{place}) -->" if has_content
          htmls << "<!-- End Qlive Insertions (#{place}) -->\n" if has_content
          htmls.join("\n")
        end
      end
    end



    def prepare(args={})
      @session = args[:session]
      @request = args[:request]
      InsertionPoints.each do |place|
        instance_variable_set("@#{place}", [ ])
      end
      prepare_assets
    end

    def registration
      self.class.suite_registration
    end

    def suite_name
      self.registration.name
    end

    def before_each_suite(rack_request)
      # override in suite
    end

    def before_suite_response(status, headers, body)
      # override in suite
    end

    # DEPRECATED
    def before_each_request(rack_request)
      Qlive.logger.warn("Qlive suite '#{suite_name}' uses deprecated 'before_each_request' method. Rename it to 'before_each_suite'.")
      before_each_suite(rack_request)
    end

  end
end