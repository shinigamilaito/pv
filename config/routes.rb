Rails.application.routes.draw do
  post 'configuration/quotation_printing_modal_image', as: :quotation_modal_image

  resources :todo_lists
  resources :subcategories do
    collection do
      get :search
    end
  end

  resources :categories do
    collection do
      get :search
    end

    member do
      get :subcategories
    end
  end

  resources :quotation_printings, only: [:index, :new, :create, :update] do
    collection do
      get :data_carousel
      delete :delete_printing_product_quotation
      post :add_printing_product
      get :obtain_total_costs
      post :update_real_price_product
      post :update_price_product
      post :update_quantity_product
      get :find_quotation_printings_by_client
      get :obtain_printing_products
      get :obtain_printing_products_for_quotation
      get :all
      get :all_by_client

    end
    member do
      get :get_pdf
      get :generate_ticket
      post :add_history
      post :cancel
    end
  end

  resources :invitations do
    collection do
      get :autocomplete
      get :search
    end
  end

  resources :content_for_invitations do
    collection do
      get :autocomplete
      get :search
    end
  end

  resources :partial_sales, only: [:index, :new, :create] do
    get :find_partial_sales_by_client, on: :collection
    get 'generate_ticket', on: :member
  end

  resources :printing_sales, only: [:index, :new, :create] do
    collection do
      patch :update_sale_unit
      delete :delete_product
      post :update_real_price_product
      post :update_quantity_product
      post :update_price_product
      get :search_sales
    end
  end

  resources :printing_products do
    collection do
      get :search
      get :search_sales
      get :autocomplete
      get :autocomplete_invitations
      get :data_carousel
    end
  end

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
  get 'cashes/report_close_cashes'

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
  get 'ticket_printing_sale/:id_printing_sale', to: 'pdfs#ticket_paid_printing_sales', as: :generate_ticket_printing_sale

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
