require 'uri'
require 'qlive/setup'
require 'qlive/suite'

module Qlive
  module Registry

    $qlive_registrations_by_name ||= {}
    $qlive_registrations_by_class ||= {}

    class Registration
      attr_accessor :name
      attr_accessor :path
      attr_accessor :klass
      attr_accessor :extras

      def initialize(args)
        [ :name, :path, :klass ].each do |var|
          instance_variable_set("@#{var}", args[var])
        end
      end
    end

    def self.find_suites
      base_path = Qlive.setup[:base_path]
      Dir.glob("#{base_path}#{base_path.end_with?('/') ? '' : '/'}**/*qlive.rb").sort.flatten.each do |path|
        name = self.extract_suite_name_from_path(path)
        unless all_by_name[name]
          all_by_name[name] = Registration.new(
              :name => name,
              :path => path)
          @qlive_current_suite_name = name
          load(path.to_s)
          @qlive_current_suite_name = nil
        end
      end
      all_by_name
    end

    def self.build_suite(suite_name)
      suite_name = URI.unescape(suite_name)
      registration = Registry.all_by_name[suite_name]
      unless registration || Qlive.setup[:skip_suite_reloader]
        Registry.find_suites
        registration = Registry.all_by_name[suite_name]
      end
      raise "Qlive Suite not found: #{suite_name}" unless registration
      load registration.path
      klass = registration.klass
      raise "Qlive could not find class for suite: #{suite_name}" unless klass
      klass.new
    end

    def self.register_class(klass)
      registration = $qlive_registrations_by_class[klass]
      registration ||= Registry.all_by_name[@qlive_current_suite_name]
      if registration
        registration.klass = klass
        $qlive_registrations_by_class[klass] = registration
      else
        Qlive.logger.warn "Ignoring Qlive class '#{klass}'. File must be placed within the Qlive base_path: #{Qlive.setup[:base_path]}. Or you can change the base_path with Qlive.setup[:base_path] = /some/other/path"
      end
      registration
    end

    def self.reset_all
      $qlive_registrations_by_name = {}
      $qlive_registrations_by_class = {}
    end

    def self.all_by_name
      $qlive_registrations_by_name
    end

    private

    def self.extract_suite_name_from_path(path)
      path.sub(Qlive.setup[:base_path], '').sub(/_?qlive\.rb$/, '').sub(/^\//, '').sub(/\/$/, '')
    end

  end
end