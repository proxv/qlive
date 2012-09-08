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
      gem 'capybara-webkit', '~> 0.10'
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

### Sauce Labs Integration

* Create a spec outside of the normal spec directory. Eg:

    sauce/sauce_spec.rb

* It might look like:

```ruby
require_relative '../spec/spec_helper.rb'
require 'sauce'
require 'sauce/capybara'

Sauce.config do |c|
  c[:start_tunnel] = true
end

Capybara.default_driver = :sauce

$all_tests_passed = nil
Qlive.setup[:before_suites] = lambda {
  Capybara.current_driver = :sauce
  $all_tests_passed = true
}

Qlive.setup[:after_suites] = lambda {
  driver = Capybara.current_session.driver
  session_id = driver.browser.session_id
  driver.browser.quit
  driver.instance_variable_set(:@browser, nil)

  job = Sauce::Job.new('id' => session_id)
  job.passed = $all_tests_passed
  job.save
}

def job_name(config=nil)
  config ||= Sauce::Config.new.opts
  "Qlive tests in #{config[:browser]}#{config[:browser_version] || ''} on #{config[:os]} at #{Time.now.to_s}"
end

def setup_session(config)
  config.each do |key, value|
    value = value || ''
    ENV["SAUCE_#{key.to_s.upcase}"] = value.to_s
  end

  ENV['SAUCE_JOB_NAME'] ||= job_name(config)
end

def record_result(example)
  $all_tests_passed = false if example.exception
end

[[ 'firefox', nil, 'Windows 2003' ], [ 'iexplore', 8, 'Windows 2003' ], [ 'iexplore', 9, 'Windows 2008' ]].each do |browser, version, os|
  config = {
    :browser => browser,
    :browser_version => version,
    :os => os
  }
  describe job_name(config) do
    run_qlive(:before_each => lambda {
      setup_session(config)
      puts "Running #{job_name}"
    }, :after_each => lambda { |example|
      record_result(example)
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
  :after_each gets passed the current rspec [example](http://rdoc.info/github/rspec/rspec-core/RSpec/Core/ExampleGroup#example-instance_method) as its one and only parameter.

