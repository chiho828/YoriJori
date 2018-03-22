Rails.application.routes.draw do
  devise_for :users
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  
  root 'yojo#index'
  
  # search
  get '/yojo/combine' => 'yojo#combine'
  get '/yojo/switch' => 'yojo#switch'
  
  # yori CRUD
  get '/yojo/new_yori' => 'yojo#new_yori'
  get '/yojo/post_yori' => 'yojo#post_yori'
  get '/yojo/yori/:yori_id' => 'yojo#yori'
  get '/yojo/edit_yori/:yori_id' => 'yojo#edit_yori'
  get '/yojo/update_yori/:yori_id' => 'yojo#update_yori'
  
  # kitchen
  get '/yojo/kitchen' => 'yojo#kitchen'
  get '/yojo/addIngredients' => 'yojo#addIngredients'
  
  # yoribook
  get '/yojo/yori_book' => 'yojo#yori_book'
  
  get 'users/:id' => 'users#show'
  
  
  # Testing post
  get '/posts/new' => 'posts#new'
  get '/posts/create' => 'posts#create'
  get '/posts/index' => 'posts#index'
  get '/posts/show/:yori_id' => 'posts#show'
  post '/posts/destroy/:yori_id' => 'posts#destroy'
  get '/posts/edit/:yori_id' => 'posts#edit'
  get '/posts/update/:yori_id' => 'posts#update'
  
  # Testing comments
  get '/posts/show/:yori_id/comments/create' => 'comments#create'
  post '/posts/show/:yori_id/comments/destroy/:comment_id' => 'comments#destroy'
end