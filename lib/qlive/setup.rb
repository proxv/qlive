module Qlive
  @qlive_config = {
    :base_path => nil, # required. qlive-rails sets this to "#{Rails.root}/spec/qunits"
    :url_prefix => '/qlive/sources',
    :magic_param => 'qlive',
    :js_support_relpath => '/qunit_support',  # gets loaded before all of the qunit js tests
    :skip_suite_reloader => false,  # when true, does not re-crawl base_path looking for suites whenever a suite_name is missing
    :gem_dev_mode => true
  }

  def self.setup
    @qlive_config
  end
end
