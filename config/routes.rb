Rails.application.routes.draw do
  devise_for :users, controllers: {
    registrations: "users/registrations",
    sessions: "users/sessions"
  }

  namespace :admin do
    get "dashboard", to: "dashboard#index"
    resources :users, only: [:index] do
      member do
        patch :promote
        patch :demote
        patch :timeout
        patch :clear_timeout
      end
    end
  end

  get "/login", to: "home_page#login", as: :login
  get "/register", to: "home_page#register"
  post "/register", to: "home_page#create_user"

  get "/profile/edit", to: "users#edit_profile", as: :edit_profile
  patch "/profile/update", to: "users#update_profile", as: :update_profile
  get "/profile/password", to: "users#edit_password", as: :edit_password
  patch "/profile/password/update", to: "users#update_password", as: :update_password

  resources :users, only: [:index]

  resources :friendships, only: [:create] do
    member do
      patch :accept
      delete :decline
    end
  end

  get "/friend_requests", to: "friendships#requests", as: :friend_requests
  get "/friends", to: "friendships#friends", as: :friends

  resources :posts, only: [:index, :new, :create, :show, :destroy] do
    resources :comments, only: [:create, :destroy]
    resources :ratings, only: [:create]
  end

  resources :skills, only: [:index, :show]

  get "up" => "rails/health#show", as: :rails_health_check

  root to: "home_page#index"
end
