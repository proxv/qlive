# Qlive

Qlive is a full-stack integration testing tool for running QUnit JavaScript tests against a live Rack server.
It is mainly intended to be used for testing JavaScript-heavy, single-page web applications
(like those built using Backbone, AngularJS, Ember.js, etc.).


Qlive's primary purpose is to enable testing with deterministic fixturing. It lets you precisely define a page's content
and user login state server-side, so you can avoid the problem of tests that sometimes pass and sometimes fail.


## Benefits:

* Precisely set fixture content and user login state for your QUnit tests using your favorite fixtures library (like factory\_girl).
* Run the same tests both in a browser or headlessly, alongside your normal integration test suite (with the qlive-rspec gem).
* A dashboard page to link to all of your qlive test suites (with the qlive-rails gem).


## Installation

### Ruby on Rails

If you are using Ruby on Rails, you should use one of these gems:

* [qlive-rails](https://github.com/proxv/qlive/tree/master/gems/qlive-rails) Configures qlive for use with Ruby On Rails and provides an index page linking to your qlive test suites.
* [qlive-rspec](https://github.com/proxv/qlive/tree/master/gems/qlive-rspec) Run your QUnit tests headlessly as an Rspec example. (Builds on qlive-rails.)

You can install them with <code>gem install qlive-rspec</code> or by adding the appropriate Gemfile entry.


### Non-Rails

To test Sinatra or other Rack applications, use the core qlive gem direclty:

* [qlive middleware](https://github.com/proxv/qlive/tree/master/gems/qlive) Rack middleware for inserting the QUnit-related scripts and for triggering fixturing hooks.


## Usage

See the [Qlive suites wiki page](https://github.com/proxv/qlive/wiki/qlive-suites).

