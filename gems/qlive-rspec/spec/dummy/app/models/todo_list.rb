class TodoList < ActiveRecord::Base

  has_many :todos

  def to_hash(options={})
    self.todos.map(&:to_hash)
  end

end
