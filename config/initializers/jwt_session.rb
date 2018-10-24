# frozen_string_literal: true

# Redis configuration will by default use REDIS_URL environment variable
# JWTSessions will use database 0 while Sidekiq will use database 1
# Redis supports databases 0 - 15
JWTSessions.redis_db_name = '0'
JWTSessions.redis_url = (ENV.fetch('REDIS_URL') { 'redis://localhost:6379' }).to_s

# TODO: change to HS512?
JWTSessions.algorithm = 'HS256'
JWTSessions.encryption_key = Rails.application.credentials.dig(:secret_jwt_encryption_key)
