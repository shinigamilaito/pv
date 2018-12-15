Rails.application.routes.draw do
  resources :client_types
  resources :payment_types
  resources :brands
  resources :equipments
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
