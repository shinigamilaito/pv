Rails.application.routes.draw do
  devise_for :users

  root "services#new"

  resources :services do
    get 'find_folios', on: :collection
    get 'add_spare_part', on: :collection
    put 'update_worforce', on: :collection
    put 'update_discount', on: :collection
    get :generate_ticket, on: :member
    put :update_quantity, on: :collection
  end

  resources :spare_parts do
    get 'autocomplete', on: :collection
    get 'search', on: :collection
  end

  resources :incomes do
    get :pending_services, on: :collection
    get 'search', on: :collection
  end

  resources :generic_prices do
    get 'autocomplete', on: :collection
    get 'search', on: :collection
  end

  resources :equipment_models do
    get 'autocomplete', on: :collection
    get 'search', on: :collection
  end

  resources :brands do
    get 'autocomplete', on: :collection
    get 'search', on: :collection
  end

  resources :equipments do
    get 'autocomplete', on: :collection
    get 'search', on: :collection
  end

  resources :clients do
    get 'autocomplete', on: :collection
  end

  resources :employes do
    get 'search', on: :collection
  end

  resources :equipment_customers do
    get 'search', on: :collection
    post 'add_history_message', on: :collection
  end

  resources :client_types
  resources :payment_types

  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end
