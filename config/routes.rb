Rails.application.routes.draw do
  devise_for :users
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  
  # kitchen - post
  get '/yojo/addIngredients' => 'yojo#addIngredients'
  
  # Read
  root 'yojo#index'
  get '/yojo/combine' => 'yojo#combine'
  get '/yojo/switch' => 'yojo#switch'
  get '/yojo/kitchen' => 'yojo#kitchen'
  get '/yojo/new_yori' => 'yojo#new_yori'
  # yori - post
  get '/yojo/post_yori' => 'yojo#post_yori'
  get '/yojo/yori' => 'yojo#yori'
  get '/yojo/yori_book' => 'yojo#yori_book'
 
  
  
  
  
  # Testing post
  get '/posts/new' => 'posts#new'
  get '/posts/create' => 'posts#create'
  get '/posts/index' => 'posts#index'
  get '/posts/show/:yori_id' => 'posts#show'
end