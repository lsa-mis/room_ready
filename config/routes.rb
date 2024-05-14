Rails.application.routes.draw do
  resources :zones
  resources :resources
  resources :rooms
  resources :floors
  resources :buildings
  devise_for :users, controllers: {omniauth_callbacks: "users/omniauth_callbacks", sessions: "users/sessions"} do
    delete 'sign_out', :to => 'users/sessions#destroy', :as => :destroy_user_session
  end

  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Reveal health status on /up that returns 200 if the app boots with no exceptions, otherwise 500.
  # Can be used by load balancers and uptime monitors to verify that the app is live.
  # get "up" => "rails/health#show", as: :rails_health_check

  # Defines the root path route ("/")
  # root "posts#index"
  root 'static_pages#about'

  get 'static_pages/about'

  get 'home', to: 'static_pages#home', as: :home

  mount LetterOpenerWeb::Engine, at: "/letter_opener" if Rails.env.development? || Rails.env.staging?

  # Place this at the very end of the file to catch all undefined routes
  # get '*path', to: 'application#render_404', via: :all

end
