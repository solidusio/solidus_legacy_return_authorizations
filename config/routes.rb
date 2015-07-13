Spree::Core::Engine.routes.draw do
  namespace :api, defaults: { format: 'json' } do
    concern :legacy_return_routes do
      resources :legacy_return_authorizations, except: [:new, :create] do
        member do
          put :add
          put :cancel
          put :receive
        end
      end
    end
    resources :checkouts, only: [], concerns: :legacy_return_routes
    resources :orders, only: [], concerns: :legacy_return_routes
  end

  namespace :admin do
    resources :orders, except: [:show] do
      resources :legacy_return_authorizations, except: [:new, :create] do
        member do
          put :fire
        end
      end
    end
  end
end
