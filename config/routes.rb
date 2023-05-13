Rails.application.routes.draw do
  root 'incidents#index'
  resources :incidents
  get '/auth/slack/callback', to: 'sessions#create'
  post '/slack/command', to: 'slack/commands#handle_incidents'
  post '/slack/create_incident', to: 'slack/commands#create_incident'
end
