Rails.application.routes.draw do
  root  'static_pages#home'
  get   '/signup', to: 'users#new'
  post  '/signup', to: 'users#create'
  get   '/login', to: 'sessions#new'
  post  '/login', to: 'sessions#create'
  post '/guest_login', to: 'sessions#new_guest'
  delete '/logout', to: 'sessions#destroy'
  resources :users do
    member do
      get :favorite_books, :following, :followers
    end
  end
  resources :account_activations, only: [:edit]
  resources :password_resets, only: %i[new create edit update]
  resources :books do
    collection do
      get :search
    end
    resources :chapters, only: %i[new create edit update destroy], param: :number
  end
  resources :favorites, only: %i[create destroy], param: nil
  resources :relationships, only: %i[create destroy]
end
