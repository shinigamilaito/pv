Rails.application.routes.draw do
  resources :sales
  resources :products do
    get :search, on: :collection
  end
  get '/pages/issue_744' => 'pages#issue_744'
  get '/pages/issue_729' => 'pages#issue_729'
  get '/pages/issue_709' => 'pages#issue_709'
  get '/pages/issue_45080858' => 'pages#issue_45080858'
  get '/pages/issue_45329522' => 'pages#issue_45329522'
  get '/pages/issue_672' => 'pages#issue_672'
  get '/pages/issue_43980674' => 'pages#issue_43980674'
  get '/pages/issue_608' => 'pages#issue_608'
  get '/pages/issue_38311828' => 'pages#issue_38311828'
  get '/pages/issue_540' => 'pages#issue_540'
  get '/pages/issue_435' => 'pages#issue_435'
  get '/pages/issue_124' => 'pages#issue_124'
  get '/pages/issue_250' => 'pages#issue_250'
  get '/pages/issue_353' => 'pages#issue_353'
  get '/pages/issue_339' => 'pages#issue_339'
  get '/pages/issue_330' => 'pages#issue_330'
  get '/pages/issue_327' => 'pages#issue_327'
  get '/pages/issue_326' => 'pages#issue_326'
  get '/pages/issue_321' => 'pages#issue_321'
  get '/pages/issue_428' => 'pages#issue_428'
  get '/pages/issue_474' => 'pages#issue_474'

  devise_for :users

  root "sales#index"

  resources :services do
    get 'find_folios', on: :collection
    get 'add_spare_part', on: :collection
    put 'update_worforce', on: :collection
    put 'update_discount', on: :collection
    get :generate_ticket, on: :member
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

  resources :client_types
  resources :payment_types

  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end
