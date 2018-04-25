Rails.application.routes.draw do
  devise_for :users
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  
  resources :galleries
  resources :paintings
  
  root 'yojo#index'
  get '/:page_number' => 'yojo#index'
  
  # search
  get '/yojo/combine/:page_number' => 'yojo#combine'
  get '/yojo/switch' => 'yojo#switch'
  
  # yori CRUD
  get '/yojo/new_yori' => 'yojo#new_yori'
  post '/yojo/post_yori' => 'yojo#post_yori'
  get '/yojo/yori/:yori_id' => 'yojo#yori'
  get '/yojo/edit_yori/:yori_id' => 'yojo#edit_yori'
  put '/yojo/update_yori/:yori_id' => 'yojo#update_yori'
  delete '/yojo/destroy_yori/:yori_id' => 'yojo#destroy_yori'
  
  # kitchen
  get '/yojo/kitchen/:user_id' => 'yojo#kitchen'
  put '/yojo/addIngredients' => 'yojo#addIngredients'
  
  # yoribook
  get '/yojo/yori_book/:user_id' => 'yojo#yori_book'
  get '/yojo/booktab' => 'yojo#booktab'
  
  # like
  post '/yojo/like' => 'yojo#like'
  
  # scrap
  post '/yojo/scrap' => 'yojo#scrap'
  
  # follow
  post '/yojo/follow' => 'yojo#follow'
  delete '/yojo/unfollow' => 'yojo#unfollow'
  
  # comments
  post '/yojo/yori/:yori_id/comments/create' => 'comments#create'
  delete '/yojo/yori/:yori_id/comments/destroy/:comment_id' => 'comments#destroy'
end