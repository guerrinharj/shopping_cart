require 'sidekiq/web'

Rails.application.routes.draw do
  mount Sidekiq::Web => '/sidekiq'

  resource :cart, only: %i[show create update destroy] do
    post :add_product  
    delete :remove_product 
  end

  resources :products

  get "up" => "rails/health#show", as: :rails_health_check

  root "rails/health#show"
end

