module AddingTodos
  class SkipThisQlive
    include Qlive::Suite

    def pages_to_test
      $methods_called_in_SkipThisQlive << :pages_to_test
      [ '/#colors/red' ]
    end

    def before_each_suite(rack_request)
      $methods_called_in_SkipThisQlive << :before_each_suite
      Todo.destroy(Todo.all.map(&:id))
      2.times { FactoryGirl.create(:todo) }
    end

    def rspec_tags
      $methods_called_in_SkipThisQlive << :rspec_tags
      { :very_redundant => true }
    end

  end
end
