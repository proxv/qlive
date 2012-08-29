class Todo < ActiveRecord::Base

  belongs_to :todo_list
  attr_accessible :content, :due_date


  def to_hash(options={})
    serializable_hash(:only => [ :content ])
  end


end
