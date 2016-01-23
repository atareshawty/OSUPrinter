Rails.application.routes.draw do
  devise_for :users

  root 'static_pages#home'
  get 'guests', to: 'static_pages#show_guest_login'
  post 'guests', to: 'static_pages#create_guest_login'
end
