module Qlive
  module SuitesHelper

    def hrefs_for_suite(suite)
      return [] unless suite.respond_to?(:pages_to_test)
      href_array(suite, suite.pages_to_test)
    end


    private

    def href_array(suite, val)
      if val.nil?
        [ ]
      elsif val.kind_of?(String)
        [ append_suite_command(suite, val) ]
      elsif val.kind_of?(Array)
        val.map { |v| append_suite_command(suite, v)}
      else
        href_array(suite, val.call)
      end
    end


    def append_suite_command(suite, href)
      param = "qlive=#{suite.name}"
      # todo: use url/uri library to make this cleaner
      pos = href.index('?')
      if pos
        res = "#{href[0, pos + 1]}#{param}&#{href[(pos + 1)..-1]}"
      else
        pos = href.index('#')
        if pos
          res = "#{href[0, pos]}?#{param}#{href[pos..-1]}"
        else
          res = "#{href}?#{param}"
        end
      end
      res
    end



  end
end
