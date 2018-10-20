# frozen_string_literal: true

Rails.application.routes.draw do
  post '/cookie/login', to: 'cookie_authentications#create'
  delete '/cookie/logout', to: 'cookie_authentications#destroy'
  post '/cookie/refresh', to: 'refresh_cookies#create'
  post '/token/login', to: 'token_authentications#create'
  delete '/token/logout', to: 'token_authentications#destroy'
  post '/token/refresh', to: 'refresh_tokens#create'

  namespace :api, constraints: { format: :json } do
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
