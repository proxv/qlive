# Qlive-Rspec

Run qlive-rails qunit javascript tests headlessly alongside your normal rspec integration examples.

This builds on the [qlive-rails](https://github.com/proxv/qlive-rails) gem. If you are using Ruby on Rails and rspec,
this gem will let you run your qlive tests in both a browser and headlessly as an rspec example/test.

Qlive-rspec has relatively heavy dependencies: virtual X11 frame buffer, headless webkit, capybara, and rspec.
If this doesn't work for you, it should be possible to incorporate your qlive tests into other automated testing
or continuous integration enviornments (eg, with a selenium-related library.)



## Installation

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




## Usage

### qunits_spec.rb

* After you have your [qlive suites](https://github.com/proxv/qlive/wiki/qlive-suites) working in a browser,
create ``spec/qunits/qunits_spec.rb``:

```ruby
  require "spec_helper.rb"
  include Qlive::Runner

  describe "qunits" do
    run_qlive
  end
```


* It will now run as a normal rspec example:
<pre>rspec spec/qunits</pre>


### Configuration

* Optionally run setup/teardown code before and after the qlive tests are run.
<pre>
Qlive.setup[:before_suites] lambda { my_setup_code }
Qlive.setup[:after_suites] lambda { my_teardown_code }
</pre>

* Optionally set xvfb/headless gem to a custom configuration hash with: ``Qlive.setup[:headless_config] = my_settings_hash``

* Optionally disable xvfb with ``Qlive.setup[:start_xvfb] = false`` if you plan on configuring it externally

* Optionally change per-page timeout in seconds with: ``Qlive.setup[:capybara_wait_time] = 30``
