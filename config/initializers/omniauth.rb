Rails.application.config.middleware.use OmniAuth::Builder do
  provider :slack, '5254735739361.5235501778662', 'Client Secret', scope: 'team:read,users:read,identify,bot'
end