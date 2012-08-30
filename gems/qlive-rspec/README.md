# Qlive-Rspec

Run qlive-rails qunit javascript tests headlessly alongside your normal rspec integration examples.
This builds on the [qlive-rails](https://github.com/proxv/qlive-rails) gem. If you are using Ruby on Rails and rspec,
this gem will let you run your qlive tests in both a browser and headlessly as an rspec example/test.


Qlive-rspec has relatively heavy dependencies: virtual X11 frame buffer, headless webkit, capybara, and rspec.
If this doesn't work for you, it should be possible to incorporate your qlive tests into other automated testing
or continuous integration enviornments (eg, with a selenium-related library.)



## Headless Webkit



* Install webkit-qt and xvfb on your system. Eg:
<pre>sudo aptitude install libqt4-dev xvfb</pre>

note: See [capybara-webkit](https://github.com/thoughtbot/capybara-webkit) and [headless](https://github.com/leonid-shevtsov/headless) gems for more detailed instructions.


* Add qlive-rails and qlive-rspec to your Gemfile as follows:

    ```ruby
    group :test, :development do
      gem 'qlive-rails', :require => 'qlive/engine'
    end

    group :test do
      gem 'qlive-rspec'
    end
    ```

* As in qlive-rails, mount the engine in routes.rb:

    ```ruby
    if Rails.env != 'production'
      mount Qlive::Engine => '/qlive'
    end
    ```



### qunits_spec.rb

* After you have your [qlive suites](https://github.com/proxv/qlive/wiki/qlive-suites) working in a browser,
create ``spec/qunits/qunits_spec.rb``:

```ruby
  require "spec_helper.rb"  
  include Qlive::Runner
  
  Capybara.current_driver = :webkit

  describe "qunits" do
    run_qlive
  end
```


* It will now run as a normal rspec example:
<pre>rspec spec/qunits</pre>


## Sauce

You can use qlive-rspec to run cross-browser tests using Sauce Labs.

### Installation

* create account with Sauce Labs
* config/ondemand.yml with your password
* install java sdk
* add gem 'sauce' to Gemfile in :test group

### sauce rspec

* Create a spec outside of the normal spec directory. Eg:

    sauce/sauce_spec.rb
    
* It might look like:
    
```ruby
require "spec_helper.rb"
require 'sauce'
require 'sauce/capybara'

include Qlive::Runner

Capybara.default_driver = :sauce

Sauce.config do |c|
  c[:start_tunnel] = true
end

[[ 'firefox', nil, 'Windows 2003' ], [ 'iexplore', 8, 'Windows 2003' ], [ 'iexplore', 9, 'Windows 2008' ]].each do |browser, version, os|
  version ||= ''
  describe "sauce qunits browser '#{browser}#{version.kind_of?(Fixnum) ? version.to_s : ''}' #{os}" do
    run_qlive(:before_each => lambda {
      puts "Switching sauce to use browser #{browser}, version #{version}, os #{os}"
      ENV['SAUCE_BROWSER'] = browser
      ENV['SAUCE_BROWSER_VERSION'] = version.to_s
      ENV['SAUCE_JOB_NAME'] = "My Qlive Tests in #{browser}#{version} on #{os} at #{Time.now.to_s}"
      ENV['SAUCE_OS'] = os
    })
  end
end

```

## Configuration Options

* Optionally run setup/teardown code before and after the qlive tests are run.
<pre>
Qlive.setup[:before_suites] lambda { my_setup_code }
Qlive.setup[:after_suites] lambda { my_teardown_code }
</pre>

* Optionally set xvfb/headless gem to a custom configuration hash with: ``Qlive.setup[:headless_config] = my_settings_hash``

* Optionally disable xvfb with ``Qlive.setup[:start_xvfb] = false`` if you plan on configuring it externally

* Optionally change per-page timeout in seconds with: ``Qlive.setup[:capybara_wait_time] = 30``

* Optionally pass in ``:before_each`` and ``:after_each`` proc/lambda in ``run_qlive`` (called in qunits_spec.rb)
