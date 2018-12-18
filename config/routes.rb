Rails.application.routes.draw do
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
  resources :supports

  resources :equipment_customers do
    get 'search', on: :collection
  end

  devise_for :users
  get 'welcome/index'
  root "equipment_customers#search"
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end
