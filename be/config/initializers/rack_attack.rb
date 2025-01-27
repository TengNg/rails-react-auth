if Rails.env.development? || Rails.env.test?
  Rack::Attack.cache.store = ActiveSupport::Cache::MemoryStore.new
end

Rack::Attack.throttle('registers/ip', limit: 10, period: 2.minutes) do |req|
  if req.path == '/auth/register' && req.post?
    req.ip
  end
end

Rack::Attack.throttle('logins/ip', limit: 10, period: 2.minutes) do |req|
  if req.path == '/auth/login' && req.post?
    req.ip
  end
end
