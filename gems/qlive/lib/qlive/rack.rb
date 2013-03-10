require 'qlive/setup'
require 'qlive/registry'

module Qlive
  class Rack

    def initialize(app, opts)
      Qlive.setup.merge!(opts)
      @app = app
      @regex_qs = /#{opts[:magic_param] || 'qlive'}=([^&\?]+)/i
      Registry.find_suites
    end

    def call(env)
      suite = nil
      if env["REQUEST_METHOD"].upcase == 'GET'
        m = @regex_qs.match(env['QUERY_STRING'])
        if m && m.length > 0
          request = ::Rack::Request.new(env)
          suite = Registry.build_suite(m[1])
          suite.prepare({
                          :request => request,
                          :session => env["rack.session"]
                        })
          suite.before_each_suite(request)
        end
      end

      status, headers, body = @app.call(env)

      if suite
        suite.before_suite_response(status, headers, body)
        inject_html(:after_open, :head, suite.html_after_head_open, body, headers)
        inject_html(:before_close, :head, suite.html_before_head_close, body, headers)
        inject_html(:after_open, :body, suite.html_after_body_open, body, headers)
        inject_html(:before_close, :body, suite.html_before_body_close, body, headers)
      end

      [status, headers, body]
    end


    protected


    private

    def inject_html(place, tag_type, html, body, headers)
      return if !html || html.length == 0
      html = html.join("\n") if html.kind_of?(Array)

      if place == :before_close
        regex = /<\/#{tag_type}>/i
        substitution = "\n#{html}\n</#{tag_type}>"
      else # :after_open
        regex = /<#{tag_type}[^>]*>/i
        substitution = "\\0\n#{html}\n"
      end

      body.each do |part|
        if part =~ regex
          part.sub!(regex, substitution)
          fix_content_length(headers, html)
          break
        end
      end
    end

    def fix_content_length(headers, inserted_text)
      if headers['Content-Length'] && inserted_text && inserted_text.length > 0
        headers['Content-Length'] = (headers['Content-Length'].to_i + inserted_text.length).to_s
      end
    end


  end
end