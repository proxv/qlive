
# Dummy App

I randomly grabbed a demo app that uses rails and backbone:
https://github.com/mulderp/Backbone-on-Rails-todoDemo

## set up gems and db
```
cd qlive/gems/qlive-rspec/spec/dummy
bundle install
rake db:create db:migrate
```

## Run dummy app qlive suites in browser
```
cd qlive/gems/qlive-rspec/spec/dummy
rails s -p 3000
http://localhost:3000/qlive
```

## Run dummy app qlive suites headlessly
```
cd qlive/gems/qlive-rspec
rspec spec/qunits
```

This broke, it's not using dummy Gemfile. (TODO: require investigate how to require external Gemfile.) 

Workaround:
```
cd qlive/gems/qlive-rspec/spec/dummy
bundle exec rspec ../../spec/
```
