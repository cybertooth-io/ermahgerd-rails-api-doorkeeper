# frozen_string_literal: true

Rails.application.routes.draw do
  use_doorkeeper
  # Sidekiq Console
  # RTFM: https://github.com/mperham/sidekiq/wiki/Monitoring#rails
  # require 'sidekiq/web'
  # mount Sidekiq::Web => '/sidekiq'

  post '/cookie/login', to: 'cookie_authentications#create'
  delete '/cookie/logout', to: 'cookie_authentications#destroy'
  post '/cookie/logout', to: 'cookie_authentications#destroy'
  post '/cookie/refresh', to: 'refresh_cookies#create'
  post '/token/login', to: 'token_authentications#create'
  delete '/token/logout', to: 'token_authentications#destroy'
  post '/token/logout', to: 'token_authentications#destroy'
  post '/token/refresh', to: 'refresh_tokens#create'

  namespace :api, constraints: { format: :json } do
    namespace :v1 do
      jsonapi_resources :roles
      jsonapi_resources :session_activities
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
