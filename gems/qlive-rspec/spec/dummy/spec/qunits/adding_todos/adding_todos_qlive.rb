class AddingTodosQlive
  include Qlive::Suite

  def pages_to_test
    Todo.destroy(Todo.all.map(&:id))
    4.times { FactoryGirl.create(:todo) }
    [ '/#colors/blue', '/#colors/brown' ]
  end

  def before_each_request(rack_request)
  end

end