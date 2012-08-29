class TodoListController < ApplicationController

  respond_to :html, :json

  def index
    @todo_list = main_list
    respond_with(@todo_list.to_hash)
  end


end
