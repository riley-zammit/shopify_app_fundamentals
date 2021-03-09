Rails.application.routes.draw do
  
  root 'app#index'
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
  get '/auth', to: 'oauth#authenticate'
  
end
