Rails.application.routes.draw do
  root 'static_pages#home'
  resources :municipalities
  resources :states
  resources :countries
  match '/new_country', to:'countries#new_country',via:'put'
  match '/new_state', to:'states#new_state',via:'put'
  match '/new_municipality', to:'municipalities#new_municipality',via:'put' 

  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end
