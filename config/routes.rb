Rails.application.routes.draw do
  resources :spare_parts do
    get :autocomplete, on: :collection
    get :search, on: :collection
  end

  resources :services, only: [:new, :create] do
    get :find_folios, on: :collection
    get :add_spare_part, on: :collection
    put :update_worforce, on: :collection
    put :update_discount, on: :collection
    put :update_quantity, on: :collection
    delete :delete_spare_part, on: :collection
  end

  resources :sales do
    delete :delete_product, on: :collection
    put :update_discount, on: :collection
    get :preview, on: :collection
  end

  resources :products do
    get :search, on: :collection
    get :search_sales, on: :collection
  end

  get 'ticket_service/:id_payment', to: 'pdfs#ticket_paid_services', as: :generate_ticket_service
  get 'note_service/:id_service', to: 'pdfs#note_services', as: :generate_note_service
  get 'ticket_sale/:id_sale', to: 'pdfs#ticket_paid_sales', as: :generate_ticket_sale

  resources :payments

  resources :incomes, only: [:index] do
    get :pending_services, on: :collection
    get :search, on: :collection
  end

  resources :generic_prices do
    get :autocomplete, on: :collection
    get :search, on: :collection
  end

  resources :equipments do
    get :autocomplete, on: :collection
    get :search, on: :collection
  end

  resources :equipment_models do
    get :autocomplete, on: :collection
    get :search, on: :collection
  end

  resources :equipment_customers, only: [:new, :create] do
    post :add_history_message, on: :collection
    get :autocomplete_cable_types, on: :collection
  end

  resources :employes do
    get 'search', on: :collection
  end

  resources :brands do
    get 'autocomplete', on: :collection
    get 'search', on: :collection
  end

  resources :clients do
    get 'autocomplete', on: :collection
  end

  devise_for :users

  root "sales#index"

  resources :payment_types
end
