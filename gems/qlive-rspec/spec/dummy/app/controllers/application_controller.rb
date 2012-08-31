class ApplicationController < ActionController::Base
  protect_from_forgery

  protected

  def main_list
    TodoList.first || TodoList.create!(:name => 'My ToDo List')
  end

end
