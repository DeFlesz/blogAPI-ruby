Rails.application.routes.draw do
  devise_for :users, controllers: { sessions: "users/sessions", registrations: "users/registrations" }
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Defines the root path route ("/")
  root "articles#index"

  namespace :admin do
    resources :users, only: [:index, :destroy, :update, :show] do
      resources :articles, only: [:index] do
        resources :comments, only: [:index]
      end
    end
    # patch '/users/:id', to: 'users#update'
    resources :articles, only: [:index]
  end

  resources :articles do
    resources :comments
  end
end
