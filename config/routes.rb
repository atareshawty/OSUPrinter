Rails.application.routes.draw do
  devise_for :users

  root 'static_pages#home'
  get 'new_print', to: 'prints#new'
  post 'file_upload', to: 'prints#file_upload'
end
