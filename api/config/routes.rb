Rails.application.routes.draw do
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
  namespace :api do
    namespace :v1 do
      resources :tasks, only: :index
      resources :auth_token, only: [:create] do
        post :refresh, on: :collection
        delete :destroy, on: :collection
        post :registration, on: :collection
      end
      resources :samples, only: [:index, :show]
      resources :likes, only: :create
      resources :categories, only: [:index]
      get :health_check, to: 'health_check#index'

      namespace :admin do
        resources :prompts, only: [:new]
        resources :samples, only: [:create, :update, :destroy]
      end
    end
  end
end
