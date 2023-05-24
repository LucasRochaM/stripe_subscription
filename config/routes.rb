Rails.application.routes.draw do
  resources :subscriptions, only: [:new, :create]
  root 'subscriptions#new'
end
