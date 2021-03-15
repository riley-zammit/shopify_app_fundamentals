Rails.application.routes.draw do
  
  root 'app#index'
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
  get '/auth', to: 'oauth#authenticate'

  get '/billing/update/:plan', to:'billing#update', as: :update_billing
  get '/billing/show', to: 'billing#show', as: :show_current_plan
  get '/billing/send_email_and_charge'
  
end
