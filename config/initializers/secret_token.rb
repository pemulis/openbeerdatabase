if Rails.env.production?
  OpenBeerDatabase::Application.config.secret_token = ENV["SECRET_TOKEN"]
else
  OpenBeerDatabase::Application.config.secret_token = SecureRandom.hex(128)
end
