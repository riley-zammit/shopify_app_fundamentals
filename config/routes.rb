Rails.application.routes.draw do
  
  root 'app#index'
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
  get '/auth', to: 'oauth#authenticate'
  get '/billing/new', to:'billing#new', as: :new_billing
  get '/billing/update', to:'billing#update', as: :update_billing
  
end
