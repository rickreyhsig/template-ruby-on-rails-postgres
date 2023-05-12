Rails.application.routes.draw do
  resources :incidents
  get 'sessions/create'
  root 'home#index'
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
  get '/auth/slack/callback', to: 'sessions#create'
  post '/slack/command', to: 'slack/commands#handle_incidents'
  post '/slack/create_incident', to: 'slack/commands#create_incident'
end
