Rails.application.routes.draw do
  root to: 'dashboard#show'

  resources :posts do
    member do
      put :like
      put :discard
    end
  end
end
