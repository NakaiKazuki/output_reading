Rails.application.routes.draw do
  root  "static_pages#home"
  get   "/signup" , to: "users#new"
  post  "/signup",  to: "users#create"
  get   "/login"  , to: "sessions#new"
  post  "/login" ,  to: "sessions#create"
  delete "/logout" , to: "sessions#destroy"
  resources :users do
    member do
      get :favorite_books,:following, :followers
    end
  end
  resources :account_activations, only: [:edit]
  resources :password_resets, only: [:new, :create, :edit, :update]
  resources :books do
    resources :chapters, only:[:new, :create, :edit, :update, :destroy],param: :number
  end
  resources :favorites,  only: [:create, :destroy],param: nil
  resources :relationships,       only: [:create, :destroy]
end
