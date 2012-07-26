require 'qlive/setup'
require 'qlive/qunit_assets'

module Qlive
  module Suite
    include QunitAssets

    attr_reader :request, :session

    InsertionPoints ||= [ 'after_head_open', 'before_head_close', 'after_body_open', 'before_body_close']

    def self.included(base)
      meta = Registry.register_class(base)
      base.class_eval do
        class << self
          attr_reader :suite_meta_data
        end
      end
      base.instance_variable_set(:@suite_meta_data, meta)

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


    def name
      self.meta_data[:name]
    end

    def meta_data
      self.class.suite_meta_data
    end


    def suite_name
      self.name
    end


    protected

    def before_each_request(rack_request)
      # override to create server-side fixtures here for the qlive request
    end

  end
end