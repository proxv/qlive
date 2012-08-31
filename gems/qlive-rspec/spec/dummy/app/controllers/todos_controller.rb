class TodosController < ApplicationController

  respond_to :html, :json

  def index
    @todo_list = main_list
    respond_with(@todo_list.to_hash)
  end

  def new
  end

  def create
    @todo = main_list.todos.create!(
      :content => params[:content]
    )
  end
end
