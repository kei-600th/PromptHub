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
      resources :samples, only: [:index, :new, :create]
      get :health_check, to: 'health_check#index'
    end
  end
end
