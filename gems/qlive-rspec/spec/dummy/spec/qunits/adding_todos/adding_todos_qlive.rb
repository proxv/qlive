class AddingTodosQlive
  include Qlive::Suite

  def pages_to_test
    [ '/#colors/blue', '/#colors/brown' ]
  end

  def before_each_request(rack_request)
    Todo.destroy(Todo.all.map(&:id))
    4.times { FactoryGirl.create(:todo) }
  end

end