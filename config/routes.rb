Rails.application.routes.draw do

  get 'app_preferences/configure_prefs', to: 'app_preferences#configure_prefs', as: :configure_prefs
  post 'app_preferences/save_configured_prefs', to: 'app_preferences#save_configured_prefs', as: 'save_configured_prefs'
  
  resources :app_preferences
  resources :announcements, only: [ :index, :show, :edit, :update ]
  resources :resource_states
  resources :specific_attribute_states
  resources :common_attribute_states, only: [:new, :create]
  resources :common_attributes, except: [:show]
  resources :room_states
  resources :room_tickets
  resources :rovers
  
  resources :zones do
    resources :buildings, module: :zones
  end
  delete 'zones/buildings/:zone_id/:id', to: 'zones/buildings#remove_building', as: :remove_building


  resources :resources
  resources :rooms do
    resources :specific_attributes, module: :rooms, except: [:show]
  end
  resources :floors
  resources :buildings
  devise_for :users, controllers: {omniauth_callbacks: "users/omniauth_callbacks", sessions: "users/sessions"} do
    delete 'sign_out', :to => 'users/sessions#destroy', :as => :destroy_user_session
  end

  resource :rover_navigation, only: [] do
    member do
      get 'zones'
      get 'buildings'
      get 'rooms'
    end
  end

  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Reveal health status on /up that returns 200 if the app boots with no exceptions, otherwise 500.
  # Can be used by load balancers and uptime monitors to verify that the app is live.
  # get "up" => "rails/health#show", as: :rails_health_check

  # Defines the root path route ("/")
  # root "posts#index"
  root to: 'static_pages#about', as: :all_root

  get 'static_pages/about'
  get 'dashboard', to: 'static_pages#dashboard', as: :dashboard
  get 'welcome_rovers', to: 'static_pages#welcome_rovers', as: :welcome_rovers

  mount LetterOpenerWeb::Engine, at: "/letter_opener" if Rails.env.development? || Rails.env.staging?

  # Place this at the very end of the file to catch all undefined routes
  # get '*path', to: 'application#render_404', via: :all

end
