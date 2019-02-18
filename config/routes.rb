Rails.application.routes.draw do
  get 'ticket_service/:id_service', to: 'pdfs#ticket_paid_services', as: :generate_ticket_service
  get 'note_service/:id_service', to: 'pdfs#note_services', as: :generate_note_service

  resources :sales do
    delete :delete_product, on: :collection
  end

  resources :products do
    get :search, on: :collection
    get :search_sales, on: :collection
  end

  devise_for :users

  root "sales#index"

  resources :services do
    get 'find_folios', on: :collection
    get 'add_spare_part', on: :collection
    put 'update_worforce', on: :collection
    put 'update_discount', on: :collection
    get :generate_service_note, on: :member
    get :generate_ticket_paid, on: :member
    put :update_quantity, on: :collection
    delete :delete_spare_part, on: :collection
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
    get :autocomplete_cable_types, on: :collection
  end

  resources :payment_types

  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end
