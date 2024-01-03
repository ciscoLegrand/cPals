Rails.application.routes.draw do
  root 'pages#index'

  # cuscom routes
  get 'chat-ia' => 'pages#chatia', as: :chatia
  get 'rails-new' => 'pages#railsnew', as: :railsnew
  get 'contact' => 'pages#contact', as: :contact
  # reources routes
  resources :conversations do
    resources :interactions
  end

  # Reveal health status on /up that returns 200 if the app boots with no exceptions, otherwise 500.
  # Can be used by load balancers and uptime monitors to verify that the app is live.
  get 'up' => 'rails/health#show', as: :rails_health_check

  # Devise routes custom
  devise_for  :users,
              path_names: {
                sign_in: 'login',
                sign_up: 'register',
                sign_out: 'logout',
                register: 'register'
              }
end
