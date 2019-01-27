Rails.application.routes.draw do
  resources :equipment_models do
    get 'autocomplete', on: :collection
  end

  resources :incomes do
    get :pending_services, on: :collection
  end

  resources :services do
    get 'find_folios', on: :collection
    get 'add_spare_part', on: :collection
    put 'update_worforce', on: :collection
    put 'update_discount', on: :collection
    resource :download, only: [:show]
  end

  resources :spare_parts do
    get 'autocomplete', on: :collection
    get 'search', on: :collection
  end

  resources :client_types
  resources :payment_types

  resources :brands do
    get 'autocomplete', on: :collection
  end

  resources :equipments do
    get 'autocomplete', on: :collection
  end

  resources :clients do
    get 'autocomplete', on: :collection
  end

  resources :employes

  # NOT USED
  resources :supports do
    get 'add_spare_part', on: :collection
    put 'update_worforce', on: :collection
    put 'update_discount', on: :collection
  end

  resources :equipment_customers do
    get 'search', on: :collection
    post 'add_history_message', on: :collection
  end

  devise_for :users
  get 'welcome/index'
  root "services#new"
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end
