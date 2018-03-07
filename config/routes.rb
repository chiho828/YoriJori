Rails.application.routes.draw do
  devise_for :users
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  
  # Read
  root 'yojo#index'
  get '/yojo/sample_kitchen(/:id)' => 'yojo#sample_kitchen'
    
  # New Recipe
  

end


