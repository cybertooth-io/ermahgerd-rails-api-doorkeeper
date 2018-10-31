# frozen_string_literal: true

# frozen_string_literal: true

JWTSessions.access_exp_time = ENV.fetch('ACCESS_EXP_TIME') { 300 } # 300 seconds (5 minutes)

# TODO: try HS512? #23
JWTSessions.algorithm = 'HS256'

JWTSessions.encryption_key = Rails.application.credentials.dig(:secret_jwt_encryption_key)

JWTSessions.jwt_options.leeway = 30 # 30 seconds (be mindful of your `access_exp_time` above)

# Redis configuration will by default use REDIS_URL environment variable
# JWTSessions will use database 0 while Sidekiq will use database 1
# Redis supports databases 0 - 15
JWTSessions.redis_db_name = '0'
JWTSessions.redis_url = (ENV.fetch('REDIS_URL') { 'redis://localhost:6379' }).to_s

JWTSessions.refresh_exp_time = ENV.fetch('REFRESH_EXP_TIME') { 604_800 } # 604800 in seconds (1 week)
