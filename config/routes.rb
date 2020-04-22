Rails.application.routes.draw do
  get 'sessions/new'
  root  "static_pages#home"
  get   "/signup" , to: "users#new"
  post  "/signup",  to: "users#create"
  get   "/login"  , to: "sessions#new"
  resources :users
end
