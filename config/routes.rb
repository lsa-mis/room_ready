Rails.application.routes.draw do

  resources :app_preferences, except: [:show] do
    collection do
      get 'configure_prefs'
      post 'save_configured_prefs'
    end
  end
  resources :announcements, only: [ :index, :show, :edit, :update ]

  resources :resource_states
  post '/resource_states/update_resource_states/:id', to: 'resource_states#update_resource_states', as: :update_resource_states
  
  resources :specific_attribute_states
  post '/specific_attribute_states/update_specific_attribute_states/:id', to: 'specific_attribute_states#update_specific_attribute_states', as: :update_specific_attribute_states

  resources :common_attribute_states
  post '/common_attribute_states/update_common_attribute_states/:id', to: 'common_attribute_states#update_common_attribute_states', as: :update_common_attribute_states

  resources :common_attributes, except: [:show]
  resources :rovers
  
  resources :zones do
    resources :buildings, module: :zones
  end
  delete 'zones/buildings/:zone_id/:id', to: 'zones/buildings#remove_building', as: :remove_building

  resources :reports, only: [:index] do
    collection do
      get 'room_issues_report', to: 'reports#room_issues_report'
      get 'inspection_rate_report', to: 'reports#inspection_rate_report'
      get 'no_access_report', to: 'reports#no_access_report'
      get 'common_attribute_states_report', to: 'reports#common_attribute_states_report'
      get 'specific_attribute_states_report', to: 'reports#specific_attribute_states_report'
      get 'resource_states_report', to: 'reports#resource_states_report'
    end
  end

  get 'dashboard', to: 'static_pages#dashboard', as: :dashboard
  resources :resources

  resources :rooms, :except => [:edit, :update]
  resources :rooms do
    resources :specific_attributes, module: :rooms, except: [:show]
    resources :room_states, module: :rooms
    resources :room_tickets, module: :rooms
  end
  resources :notes, :except => [:index]

  resources :floors
  resources :buildings do
    resources :floors do 
      resources :rooms, module: :floors
    end
  end
  post 'archive_building/:id', to: 'buildings#archive', as: :archive_building
  post 'unarchive_building/:id', to: 'buildings#unarchive', as: :unarchive_building
  post 'unarchive_building_index/:id/:show_archived', to: 'buildings#unarchive_index', as: :unarchive_building_index

  devise_for :users, controllers: {omniauth_callbacks: "users/omniauth_callbacks", sessions: "users/sessions"} do
    delete 'sign_out', :to => 'users/sessions#destroy', :as => :destroy_user_session
  end

  resource :rover_navigation, only: [] do
    member do
      get 'zones'
      get 'buildings'
      get 'rooms'
      get 'confirmation'
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

  get 'welcome_rovers', to: 'static_pages#welcome_rovers', as: :welcome_rovers

  post '/send_email_for_tdx_ticket/:room_id', to: 'rooms/room_tickets#send_email_for_tdx_ticket', as: :send_email_for_tdx_ticket

  mount LetterOpenerWeb::Engine, at: "/letter_opener" if Rails.env.development? || Rails.env.staging?

  # Place this at the very end of the file to catch all undefined routes
  # get '*path', to: 'application#render_404', via: :all

end
