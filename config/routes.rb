Rails.application.routes.draw do
  devise_for :users
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html
  resources :thoughts, only: [:new, :create, :index, :destroy] do
    collection do
      get 'page'
    end
    member do
      post 'hide'
      post 'favorite'
      post 'spotlight'
      post 'shadow'
    end
  end

  # Defines the root path route ("/")
  root "thoughts#index"
end
