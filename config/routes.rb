Rails.application.routes.draw do
  post '/login', to: 'sessions#create'
  post '/renew', to: 'refresh#create'

  namespace :v1, constraints: { format: :json } do
    jsonapi_resources :users
  end

end
