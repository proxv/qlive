# Qlive-Rails

Qlive-Rails is a Ruby on Rails engine for running qunit javascript tests using server-side factories and user login.


## Installation

* Add qlive-rails to your Gemfile:

    ```ruby
    group :development do
      gem 'qlive-rails', :require => 'qlive/engine'
    end
    ```


* Mount the engine in routes.rb:

    ```ruby
    if Rails.env == 'development'
      mount Qlive::Engine => '/qlive'
    end
    ```



For running qlive headlessly using rspec, take a look at [qlive-rspec](https://github.com/proxv/qlive-rspec).


## Usage


Wiki pages:

* [Qlive-suites](https://github.com/proxv/qlive/wiki/qlive-suites) for how to use qlive and create suites.

* [Factory_girl Tips](https://github.com/proxv/qlive/wiki/factory-girl-tips) for how to use factory girl in your qlive suites.

* [Devise Tips](https://github.com/proxv/qlive/wiki/devise-tips) for logging in users with devise in your qlive suites.

* Once you have some qlive suites in place, visit /qlive in your app and follow the links within to run them.
