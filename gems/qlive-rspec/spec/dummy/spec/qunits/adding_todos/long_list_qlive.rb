module AddingTodos
  class LongListQlive
    include Qlive::Suite

    def pages_to_test
      '/#colors/green'
    end

    def before_each_suite(rack_request)
      Todo.destroy(Todo.all.map(&:id))
      20.times { FactoryGirl.create(:todo) }
    end
  end
end
