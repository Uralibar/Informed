Rails.application.routes.draw do
  devise_for :users
  root "posts#index"



  # Route for viewing the logged-in user's posts
  get "user_posts", to: "posts#user_posts", as: "user_posts"
  get "profile/:id", to: "profiles#show", as: "user_profile"
  get "find_user_by_username", to: "profiles#find_user_by_username", as: "find_user_by_username"
  get "search_agency_users", to: "profiles#search_agency_users", as: "search_agency_users"


  resources :posts do
    resources :comments, only: [ :create, :edit, :update, :destroy ]
    member do
      post "upvote"
      post "downvote"
    end
  end



  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Reveal health status on /up that returns 200 if the app boots with no exceptions, otherwise 500.
  # Can be used by load balancers and uptime monitors to verify that the app is live.
  get "up" => "rails/health#show", as: :rails_health_check

  # Render dynamic PWA files from app/views/pwa/*
  get "service-worker" => "rails/pwa#service_worker", as: :pwa_service_worker
  get "manifest" => "rails/pwa#manifest", as: :pwa_manifest

  # Defines the root path route ("/")
  # root "posts#index"
end
