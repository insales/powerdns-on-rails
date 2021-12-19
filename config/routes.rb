Rails.application.routes.draw do
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html

  namespace :api do
    namespace :v1 do
      devise_for :api_clients, skip: [:sessions, :registrations, :confirmations]
      resources :domains, only: %i[create show update destroy] do
        resources :records, only: %i[index create show update destroy] do
          delete '/', on: :collection, action: :delete_all
        end
      end
    end
  end

  devise_for :users, skip: :all

  devise_scope :user do
    scope "sessions", controller: "sessions" do
      get "sign_in" => "sessions#new", as: :new_user_session
      post "sign_in" => "sessions#create", as: :user_session
      delete "sign_out" => "sessions#destroy", as: :destroy_user_session
    end
    scope module: :devise do
      resources :saml_sessions, only: [:new, :create, :destroy], path: 'sso/saml_sessions'
      get "sso/metadata" => "saml_sessions#metadata", as: :metadata_user_sso_session
    end
  end

  get '/idp/auth' => 'fake_idp#create', as: :fakeidpauth unless Rails.env.production?

  root :to => 'dashboard#index'

  resources :domains do
    member do
      put :change_owner
      get :apply_macro
      post :apply_macro
      put :update_note
    end

    resources :records do
      member do
        put :update_soa
      end
    end
  end

  resources :zone_templates, :controller => 'templates'
  resources :record_templates

  resources :macros do
    resources :macro_steps
  end

  # get '/audits(/:action(/:id))' => 'audits#index', :as => :audits
  resources :audits, only: :index do
    get "/domain/:id", action: :domain, on: :collection, as: :domain
  end

  resources :reports, only: :index do
    collection do
      get :results
      get :view
    end
  end

  # get '/search(/:action)' => 'search#results', :as => :search
  resource :search, controller: :search, only: :show do
    get :results
  end


  resource :auth_token
  post '/token/:token' => 'sessions#token', :as => :token

  resources :users do
    member do
      put :suspend
      put :unsuspend
      delete :purge
    end
  end

  resources :api_clients

  #match '/logout' => 'sessions#destroy', :as => :logout
end
