module Qlive
  module QunitAssets

    # default is to serve assets for qlive-rails. Override if your qunit assets are elsewhere.
    def prepare_assets
      before_body_close.concat(
        qunit_html_structure |
        qunit_framework |
        qunit_disable_autostart |
        qunit_support_assets |
        qunit_javascript_test_sources |
        qunit_finalize
      )
    end

    def qunit_framework
      [
        '<link rel="stylesheet" href="/qlive/qunit-1.9.0/qunit.css" type="text/css" media="screen" />',
        '<script type="text/javascript" src="/qlive/qunit-1.9.0/qunit.js"></script>'
      ]
    end

    def qunit_support_assets
      glob_script_tags("#{sans_slash(base_path)}#{Qlive.setup[:js_support_relpath]}")
    end

    def qunit_javascript_test_sources
      glob_script_tags(File.expand_path('..', self.registration.path))
    end

    def qunit_html_structure
      [
        '<div class="qlive-structure">',
        "<h1 id='qunit-header'>Qlive Suite: #{suite_name}</h1>",
        '<h2 id="qunit-banner"></h2>',
        '<div id="qunit-testrunner-toolbar"></div>',
        '<h2 id="qunit-userAgent"></h2>',
        '<ol id="qunit-tests"></ol>',
        '<div id="qunit-fixture">test markup, will be hidden</div>',
        '</div>'
      ]
    end

    def qunit_disable_autostart
      [
        '<script>QUnit.config.autostart = false;</script>'
      ]
    end

    def qunit_finalize
      js=<<EOJS
      <script>
        window.endQlive = function() {
          if (!$('#qlive-complete').length) {
            $('body').append('<div id="qlive-complete"></div>');
          }
        };
        QUnit.done = function(failed, passed, total, runtime) {
          window.endQlive();
        };
      </script>
EOJS
      [ js ]
    end

    def glob_script_tags(src_base_path)
      return [] unless File.exist?(src_base_path)
      sources = Dir.glob("#{src_base_path}#{trailing_slash(src_base_path)}**/*.js").sort.flatten
      sources.map do |src|
        src = src.to_s
        href = "#{url_prefix}#{src.sub(base_path, '')}"
        "<script type='text/javascript' src='#{href}'></script>"
      end
    end

    private

    def url_prefix
      @url_prefix ||= sans_slash(Qlive.setup[:url_prefix] || '')
    end

    def sans_slash(path)
      path.end_with?('/') ? path[0..-1] : path
    end

    def base_path
      Qlive.setup[:base_path]
    end

    def trailing_slash(path)
      path.end_with?('/') ? '' : '/'
    end

  end
end
