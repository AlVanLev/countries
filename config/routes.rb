Rails.application.routes.draw do
  root 'static_pages#home'
  match '/language', to: 'application#language', via:'get'

  resources :countries
  match '/add_country', to:'countries#add_country',via:'post'
  match 'country/switch_active/:id', to:'countries#switch_active', via:'put', as: 'switch_active_country'
  match '/download_countries', to: 'countries#download', via: 'get'
  match '/ajax_import_countries', to: 'countries#ajax_import_countries', via: 'post'

  resources :states
  match '/add_state', to:'states#add_state',via:'post'
  match 'state/switch_active/:id', to:'states#switch_active', via:'put', as: 'switch_active_state'
  match '/download_states', to: 'states#download', via: 'get'
  match '/ajax_import_states', to: 'states#ajax_import_states', via: 'post'

  resources :municipalities
  match '/add_municipality', to:'municipalities#add_municipality',via:'post'
  match 'municipality/switch_active/:id', to:'municipalities#switch_active', via:'put', as: 'switch_active_municipality'
  match '/download_municipalities', to: 'municipalities#download', via: 'get'
  match '/ajax_import_municipalities', to: 'municipalities#ajax_import_municipalities', via: 'post'

  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end
