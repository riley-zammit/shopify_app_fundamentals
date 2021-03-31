Rails.application.routes.draw do
  
  root 'app#index'
  get '/plan_accepted', to: 'app#billing_plan_accepted'
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
  get '/auth', to: 'oauth#authenticate'

  get '/billing/show', to: 'billing#show', as: :show_current_plan
  post '/billing/update', to:'billing#update', as: :update_billing
  post '/billing/send_email', to:'billing#send_email_and_charge'
  
end
