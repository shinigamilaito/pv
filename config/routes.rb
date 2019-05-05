Rails.application.routes.draw do
  resources :quotations, only: [:index, :new, :create, :destroy] do
    delete :delete_product, on: :collection
    get :search_products, on: :collection
    post :update_quantity_product, on: :collection
    post :update_price_product, on: :collection
    get :get_pdf, on: :member
    get :quotations_by_client, on: :collection
  end

  get 'concentrated_reports/sales'
  get 'concentrated_reports/sales_by_month_year'
  get 'concentrated_reports/sales_by_year'

  get 'concentrated_reports/services'
  get 'concentrated_reports/services_by_month_year'
  get 'concentrated_reports/services_by_year'

  get 'cashes/new_open_cash'
  post 'cashes/open_cash'
  get 'cashes/new_close_cash'
  post 'cashes/close_cash'
  get 'cashes/generate_xlsx'
  get 'cashes/ticket_open_cash'
  get 'cashes/new_movement'
  post 'cashes/create_movement'

  get 'filters_sales/range_date_incomes'
  get 'filters_sales/employee_incomes'
  get 'filters_sales/range_quantity_incomes'
  get 'filters_sales/ticket_incomes'

  get 'filters/range_date_incomes'
  get 'filters/employee_incomes'
  get 'filters/client_incomes'
  get 'filters/range_quantity_incomes'
  get 'filters/folio_incomes'

  resources :spare_parts do
    get :autocomplete, on: :collection
    get :search, on: :collection
    post :translate, on: :member
  end

  resources :services, only: [:new, :create, :update] do
    get :find_folios, on: :collection
    get :add_spare_part, on: :collection
    put :update_worforce, on: :collection
    put :update_discount, on: :collection
    put :update_quantity, on: :collection
    delete :delete_spare_part, on: :collection
  end

  resources :sales, only: [:index, :new, :create] do
    delete :delete_product, on: :collection
    put :update_discount, on: :collection
    get :preview, on: :collection
    post :update_discount_product, on: :collection
    post :update_quantity_product, on: :collection
    post :update_price_product, on: :collection
  end

  resources :products do
    get :search, on: :collection
    get :search_sales, on: :collection
    post :translate, on: :member
  end

  get 'ticket_service/:id_payment', to: 'pdfs#ticket_paid_services', as: :generate_ticket_service
  get 'note_service/:id_service', to: 'pdfs#note_services', as: :generate_note_service
  get 'ticket_sale/:id_sale', to: 'pdfs#ticket_paid_sales', as: :generate_ticket_sale

  resources :payments

  resources :incomes, only: [:index] do
    get :pending_services, on: :collection
    get :search, on: :collection
    get :pending_service_by_client, on: :collection
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
    get 'autocomplete', on: :collection
  end

  resources :brands do
    get 'autocomplete', on: :collection
    get 'search', on: :collection
  end

  resources :clients do
    get 'autocomplete', on: :collection
    get :search, on: :collection
  end

  devise_for :users

  root "welcome#index"

  resources :payment_types
end
