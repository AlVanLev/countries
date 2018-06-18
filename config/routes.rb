Rails.application.routes.draw do
  root 'static_pages#home'
  resources :municipalities
  resources :states
  resources :countries
  match '/new_country', to:'countries#new_country',via:'put'
  match '/country_active/:id', to:'countries#country_active', via:'put', as: 'country_active'
  match '/download_countries', to: 'countries#download', via: 'get'

  match '/new_state', to:'states#new_state',via:'put'
  match '/state_active/:id', to:'states#state_active', via:'put', as: 'state_active'
  match '/download_states', to: 'states#download', via: 'get'

  match '/new_municipality', to:'municipalities#new_municipality',via:'put'
  match '/municipality_active/:id', to:'municipalities#municipality_active', via:'put', as: 'municipality_active'
  match '/download_municipalities', to: 'municipalities#download', via: 'get'

  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end
