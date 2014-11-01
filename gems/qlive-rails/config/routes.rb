Qlive::Engine.routes.draw do
  get '/' => 'qlive/suites#index'
  get '/sources/*rel_path' => 'qlive/sources#show'
end
