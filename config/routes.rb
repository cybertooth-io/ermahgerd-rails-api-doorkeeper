Rails.application.routes.draw do
  post '/login', to: 'authentications#create'
  delete '/logout', to: 'authentications#destroy'
  post '/renew', to: 'renewals#create'

  namespace :api, constraints: {format: :json} do
    namespace :v1 do
      namespace :protected do
        jsonapi_resources :sessions do
          member do
            patch :invalidate
            put :invalidate
          end
        end
        jsonapi_resources :users
      end
    end
  end
end
