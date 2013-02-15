
# -*- encoding : utf-8 -*-
PowerdnsOnRails::Application.routes.draw do
  namespace :api do
    namespace :v1 do
      devise_for :api_clients, skip: [:sessions, :registrations, :confirmations]
      resources :domains do
        resources :records do
          delete on: :collection, action: :delete_all
        end
      end
    end
  end

  devise_for :users, :controllers => { :sessions => "sessions" }, :path => "sessions"

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

  match '/audits(/:action(/:id))' => 'audits#index', :as => :audits
  match '/reports(/:action)' => 'reports#index', :as => :reports

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

  get '/search(/:action)' => 'search#results', :as => :search

  #resource :session
  #match '/logout' => 'sessions#destroy', :as => :logout
  #match '/:controller(/:action(/:id))'
end
