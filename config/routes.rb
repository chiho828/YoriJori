Rails.application.routes.draw do
  devise_for :users
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  
  get '/yojo/test' => 'yojo#test'
  get '/yojo/combine' => 'yojo#combine'
  get '/yojo/switch' => 'yojo#switch'
  
  # post
  get '/yojo/addIngredients' => 'yojo#addIngredients'
  
  # Read
  root 'yojo#index'
  get '/yojo/kitchen' => 'yojo#kitchen'
  get '/yojo/yori' => 'yojo#yori'
  get '/yojo/yori_book' => 'yojo#yori_book'
  
  # New Recipe
  get '/yojo/new_yori' => 'yojo#new_yori'
  
  get '/yojo/test_index' => 'yojo#test_index'
end