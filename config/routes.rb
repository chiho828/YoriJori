Rails.application.routes.draw do
  devise_for :users
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  
  root 'yojo#index'
  get '/:page_number' => 'yojo#index'
  
  # search
  get '/yojo/combine/:page_number' => 'yojo#combine'
  get '/yojo/switch' => 'yojo#switch'
  
  # yori CRUD
  get '/yojo/new_yori' => 'yojo#new_yori'
  get '/yojo/post_yori' => 'yojo#post_yori'
  get '/yojo/yori/:yori_id' => 'yojo#yori'
  get '/yojo/edit_yori/:yori_id' => 'yojo#edit_yori'
  get '/yojo/update_yori/:yori_id' => 'yojo#update_yori'
  
  post '/yojo/destroy_yori/:yori_id' => 'yojo#destroy_yori'
  
  # kitchen
  get '/yojo/kitchen/:user_id' => 'yojo#kitchen'
  get '/yojo/addIngredients' => 'yojo#addIngredients'
  
  # yoribook
  get '/yojo/yori_book/:user_id/:page_number' => 'yojo#yori_book'
  
  get 'users/:user_id' => 'users#show'
  
  # like
  get '/yojo/like' => 'yojo#like'
  get '/yojo/unlike' => 'yojo#unlike'
  
  # scrap
  get '/yojo/scrap' => 'yojo#scrap'
  get '/yojo/unscrap' => 'yojo#unscrap'
  
  # comments
  get '/yojo/yori/:yori_id/comments/create' => 'comments#create'
  post '/yojo/yori/:yori_id/comments/destroy/:comment_id' => 'comments#destroy'
  
  
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
  
  # IDEAL ROUTES
  # get '/posts' => 'posts#index'
  # post '/posts' => 'posts#create'
  # get '/posts/new' => 'posts#new'
  # get '/posts/:id/edit' => 'posts#edit', as: "edit_post"
  # get '/posts/:id' => 'posts#show', as: "post"
  # put '/posts/:id' => 'posts#update'
  # patch '/posts/:id' => 'posts#update'
  # delete '/posts/:id' => 'posts#destroy'
end