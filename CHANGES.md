# Qlive 0.4


## Overview of 0.4 Changes

* Using PhantomJS and Poltergeist gem instead of capybara-webkit, headless, and xvfb

* Upgraded to Capybara 2

* Improved API to use a more flexible directory and naming structure for qlive suites

* Now possible to run multiple *qlive.rb files against the same js tests in a directory

* Experimental before_each_response method introduced, to permit direct modification of rack status, headers, and body


## Upgrading to 0.4: What To Do


* Follow the udpated install instructions. (See readme, mainly involves installing phantomjs, updating Gemfile, and setting Capybara driver to :poltergeist)

* Rename the ``before_each_request`` method to ``before_each_suite``

* Optonally rename suites to take advantage of the more flexible directory/naming structure. (Make sure they still end in qlive.rb)

* If you are manually stopping headless runner from your javascript for some reason (before Qunit completes) you will now need to call ``window.endQlive()`` to do so.



# Qlive 0.3

Older stuff...