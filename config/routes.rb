Rails.application.routes.draw do
  devise_for :users, controllers: { registrations: 'registrations'}

  root 'static_pages#home'
  get 'new_print', to: 'prints#new'
  post 'file_upload', to: 'prints#file_upload'
  get 'printer_options', to: 'prints#printer_options'
  post 'print_it', to: 'prints#create'
end
