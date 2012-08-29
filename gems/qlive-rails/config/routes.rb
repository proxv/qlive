Qlive::Engine.routes.draw do
  match '/' => 'qlive/suites#index'
  match '/sources/*rel_path' => 'qlive/sources#show'
end
