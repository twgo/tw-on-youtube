if RUBY_PLATFORM == "x86_64-darwin17"
  sidekiq_config = { url: 'redis://127.0.0.1:6379' }
else  
  sidekiq_config = { url: 'redis://redis:6379' }
end

Sidekiq.configure_server do |config|
  config.redis = sidekiq_config
end

Sidekiq.configure_client do |config|
  config.redis = sidekiq_config
end
