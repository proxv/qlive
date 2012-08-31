BackboneOnRailsTodo::Application.routes.draw do
  #get "todos/index"
  #get "todos/new"
  #get "todos/create"

  if Rails.env != 'production'
      mount Qlive::Engine => '/qlive'
  end

  resources :todos

  root :to => "todo_list#index"

  #match 'todolist', :controller => "todo_list", :action => "index"
end
