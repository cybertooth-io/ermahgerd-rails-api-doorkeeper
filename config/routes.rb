Rails.application.routes.draw do
  post '/login', to: 'sessions#create'
  delete '/logout', to: 'sessions#destroy'
  post '/renew', to: 'refresh#create'

  namespace :v1, constraints: { format: :json } do
    jsonapi_resources :users
  end

end
