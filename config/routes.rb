Rails.application.routes.draw do
  root 'incidents#index'
  resources :incidents
  post '/slack/command', to: 'slack/commands#handle_incidents'
  post '/slack/create_incident', to: 'slack/commands#create_incident'
end
