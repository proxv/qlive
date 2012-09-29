module Qlive
  module QunitAssets

    # default is to serve assets for qlive-rails. Override if your qunit assets are elsewhere.
    def prepare_assets
      before_body_close.concat(
        qunit_html_structure |
        qunit_support_framework |
        qunit_support_assets |
        qunit_disable_autostart |
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
      support_relpath = Qlive.setup[:js_support_relpath]
      path = "#{Qlive.setup[:base_path]}#{support_relpath}"
      if (File.exist?(path))
        glob_script_tags(path, "#{Qlive.setup[:url_prefix] || ''}#{support_relpath}")
      else
        []
      end
    end

    def qunit_javascript_test_sources
      test_path = File.expand_path('..', self.meta_data[:path])
      url_prefix = "#{Qlive.setup[:url_prefix] || ''}/#{suite_name}"
      glob_script_tags(test_path, url_prefix)
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
        '<div id="display-proxified-tests"></div>',
        '</div>'
      ]
    end

    def qunit_disable_autostart
      [
        '<script>QUnit.config.autostart = false;</script>'
      ]
    end

    def qunit_finalize
      [
        '<script>QUnit.done = function(failed, passed, total, runtime) { window.qunitComplete = true; };</script>'
      ]
    end

    def glob_script_tags(src_base_path, url_prefix)
      sources = Dir.glob("#{src_base_path}#{src_base_path.end_with?('/') ? '' : '/'}**/*.js").sort.flatten
      sources.map do |src|
        src = src.to_s
        href = "#{url_prefix}#{src.sub(src_base_path, '')}"
        "<script type='text/javascript' src='#{href}'></script>"
      end
    end

  end
end
