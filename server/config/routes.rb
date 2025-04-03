Rails.application.routes.draw do
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Reveal health status on /up that returns 200 if the app boots with no exceptions, otherwise 500.
  # Can be used by load balancers and uptime monitors to verify that the app is live.
  get "up" => "rails/health#show", as: :rails_health_check

  # Defines the root path route ("/")
  # root "posts#index"

  namespace :api do
    namespace :admin do
      post "admin_sessions", to: "admin_sessions#create"
      delete "admin_sessions", to: "admin_sessions#destroy"
      get "verify_token", to: "admin_sessions#verify_token"

      resources :clubs, only: [ :index, :new, :create, :edit, :update, :destroy ] do
        resources :managers, only: [ :index, :show, :create, :edit, :update, :destroy ], controller: "club_managers" do
        collection do
          put :update_table_numbers
        end
      end

        member do
          patch :activate
        end
      end
      get "districts", to: "clubs#districts"
      get "streets", to: "clubs#streets"
    end

    namespace :club do
      post "club_sessions", to: "club_sessions#create"
      delete "club_sessions", to: "club_sessions#destroy"
      resources :managers do
        member do
          put :update_table_numbers
        end
      end

      resources :reservations, only: [:index] do
        member do
          patch :update_status
        end
      end

      get "verify_token", to: "club_sessions#verify_token"
    end

    get "clubs", to: "clubs#index"

    namespace :player do
      post "player_sessions", to: "player_sessions#create"
      delete "player_sessions", to: "player_sessions#destroy"
      get "verify_token", to: "player_sessions#verify_token"

      resources :reservations, only: [:create, :index] do
          member do
            put :update_payment_status
          end
        end
    end

    namespace :public do
      resources :clubs, only: [ :index, :show ] do
        collection do
          post :register, to: "clubs#register"
        end
      end

      resources :players, only: [] do
        collection do
          post :register, to: "players#register"
        end
      end

      resources :districts, only: [ :index ]
      resources :streets, only: [ :index ]
    end
  end
end
