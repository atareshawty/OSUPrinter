Rails.application.routes.draw do
  devise_for :users

  root 'static_pages#home'
  get 'guests', to: 'static_pages#guest_login'
end
