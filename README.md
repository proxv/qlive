# Qlive

Qlive is a full-stack integration testing tool for running qunit javascript tests against a live server.
It is mainly intended to be used for testing javascript-heavy, single-page web applications
(like those built using backbone, angularjs, emberjs, etc.)


Qlive's primary purpose is to enable testing with deterministic fixturing. It lets you precisely define a page's content
and user login state server-side, so you can avoid the problem of tests that sometimes pass and sometimes fail.


## Benefits:

* Precisely set fixture content and user login state for your qunit tests using your favorite fixtures library (like factory_girl)
* Run the same tests both in a browser or headlessly, alongside your normal integration test suite. (with qlive-rspec gem)
* A dashboard page to link to all of your qlive test suites. (with qlive-rails gem)


## Installation

### Ruby on Rails

If you are using Ruby on Rails, you should use one of these gems:

* [qlive-rails](https://github.com/proxv/qlive/gems/qlive-rails) Configures qlive for use with Ruby On Rails and provides an index page linking to your qlive test suites.
* [qlive-rspec](https://github.com/proxv/qlive/gems/qlive-rspec) Run your qunit tests headlessly as an rspec example. (Builds on qlive-rails.)


### Non-rails:

To test Sinatra or other ruby web applications, use the core qlive gem direclty:

* [qlive middleware](https://github.com/proxv/qlive/gems/qlive) Rack middleware for inserting the qunit-related scripts and for triggering fixturing hooks


## Usage

See [suites wiki page](https://github.com/proxv/qlive/wiki/qlive-suites).

