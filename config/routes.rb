Rails.application.routes.draw do
  root 'static_pages#home'
  match '/language', to: 'application#language', via:'get'

  resources :countries
  match '/add', to:'countries#add',via:'post'
  match '/switch_active/:id', to:'countries#switch_active', via:'put', as: 'switch_active_country'
  match '/download_countries', to: 'countries#download', via: 'get'
  match '/ajax_import_countries', to: 'countries#ajax_import_countries', via: 'post'

  resources :states
  match '/add', to:'states#add',via:'put'
  match '/switch_active/:id', to:'states#switch_active', via:'put', as: 'switch_active_state'
  match '/download_states', to: 'states#download', via: 'get'
  match '/ajax_import_states', to: 'states#ajax_import_states', via: 'post'

  resources :municipalities
  match '/add', to:'municipalities#add',via:'put'
  match '/switch_active/:id', to:'municipalities#switch_active', via:'put', as: 'switch_active_municipality'
  match '/download_municipalities', to: 'municipalities#download', via: 'get'
  match '/ajax_import_municipalities', to: 'municipalities#ajax_import_municipalities', via: 'post'

  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end
