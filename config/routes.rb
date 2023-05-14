Rails.application.routes.draw do
  root 'incidents#index'
  resources :incidents do
    collection do
      get 'list'
    end
  end
  post '/slack/command', to: 'slack/commands#handle_incidents'
  post '/slack/create_incident', to: 'slack/commands#create_incident'
end
