Rails.application.routes.draw do
  resources :items

  get '/items/:id/chemist' => 'items#chemist'
  post '/items/:id/childs' => 'items#add_child'
  delete '/items/:id/childs/:child_id' => 'items#destroy_child'
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
end
