Rails.application.routes.draw do
  devise_for :users, controllers: { sessions: 'users/sessions', passwords: 'users/passwords' }
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html
  resources :thoughts, only: [:new, :create, :edit, :update, :index, :destroy] do
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
