Rails.application.routes.draw do
  root  "static_pages#home"
  get   "/signup" , to: "users#new"
  get   "/login"  , to: "sessions#new"
  resources :users
end
