Spree::Core::Engine.routes.draw do
  namespace :api, defaults: { format: 'json' } do
    concern :order_routes do
      resources :legacy_return_authorizations, except: [:new, :create] do
        member do
          put :add
          put :cancel
          put :receive
        end
      end
    end
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
