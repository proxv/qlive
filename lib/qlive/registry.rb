require 'qlive/setup'
require 'qlive/suite'

module Qlive
  module Registry

    $qlive_all_suites ||= {}

    def self.suites
      $qlive_all_suites
    end


    def self.find_suites
      suites = {}
      base_path = Qlive.setup[:base_path]
      sources = Dir.glob("#{base_path}#{base_path.end_with?('/') ? '' : '/'}**/*_qlive.rb").sort.flatten
      sources.each do |path|
        path = path.to_s
        name = self.extract_suite_name_from_path(path)
        suites[name] ||= {}
        suites[name][:path] = path
      end

      $qlive_all_suites = suites
    end

    def self.build_suite(suite_name)
      meta = Registry.suites[suite_name]
      unless meta || Qlive.setup[:skip_suite_reloader]
        Registry.find_suites
        meta = Registry.suites[suite_name]
      end
      raise "Qlive Suite not found: #{suite_name}" unless meta
      load meta[:path]
      klass = meta[:klass]
      raise "Qlive could not find class for suite: #{suite_name}" unless klass
      klass.new
    end

    def self.register_class(klass)
      name = self.extract_suite_name_from_class(klass)
      meta = Registry.suites[name] || {}
      meta.merge!(:name => name,
                  :klass => klass)
      meta
    end

    private

    def self.extract_suite_name_from_path(path)
      res = path.sub(Qlive.setup[:base_path], '').sub(/^\//, '')
      res.split('/')[0..-2].join('/')
    end

    def self.extract_suite_name_from_class(klass)
      parts = klass.name.split('::')
      parts = parts.map { |part| part.gsub(/(.)([A-Z])/,'\1_\2').downcase }
      parts.join('/').sub(/_qlive$/, '')
    end

  end
end