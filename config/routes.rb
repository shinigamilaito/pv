Rails.application.routes.draw do
  resources :brands
  resources :equipments
  resources :clients
  resources :employes

  resources :sale_supports do
    get 'search', on: :collection
  end
  resources :equipment_customers

  devise_for :users
  get 'welcome/index'
  root "welcome#index"
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end
