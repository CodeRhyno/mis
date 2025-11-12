Rails.application.routes.draw do
  root 'dashboard#index'

  get 'login', to: 'sessions#new'
  post 'login', to: 'sessions#create'
  delete 'logout', to: 'sessions#destroy'

  resources :users do
    member do
      patch :suspend
      patch :activate
    end
  end

  resources :records do
    member do
      patch :verify
      patch :object
    end
  end

  resources :permissions
  resources :circles
  resources :branches

  resources :documents, only: [] do
    collection do
      # post :verify
      get :verify, as: 'verify'
    end
    member do
      get :download
    end
  end
end
