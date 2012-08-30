# Qlive

This core Qlive gem is rack middleware that:

* provides hooks for setting server state before the request is processed by your app
* inserts the qunit framework and your test sources and helpers into the page's response.


If you are using Ruby on Rails, you should not use this gem directly. Instead, use 
[qlive-rails](https://github.com/proxv/qlive-rails) or [qlive-rspec](https://github.com/proxv/qlive-rspec).


## Configuration 

* Configure base path, the top of the directory tree that contains your qlive suites. (See suites section below)
    <pre>Qlive.setup[:base_path] = /absolute/path/to/qunit/tests/tree</pre>
* Configure url prefix for serving your test sources in this tree.
    * The default is /qlive/sources.
    * So a request to /qlive/sources/my_suite/test-stuff.js would need to resolve to #{base_path}/my_suite/test-stuff.js
* Mount Qlive::Rack late enough for it to access the database or whatever else the suite needs for preparing page state

todo: improve/complete non-rails instructions should anyone want to use it.


## Usage

See [suites wiki page](https://github.com/proxv/qlive/wiki/qlive-suites).

