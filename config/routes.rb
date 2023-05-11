Rails.application.routes.draw do
  get 'sessions/create'
  root 'home#index'
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
  get '/auth/slack/callback', to: 'sessions#create'
end
