# TODO change to HS512?
JWTSessions.algorithm = 'HS256'
JWTSessions.encryption_key = Rails.application.credentials.dig(:secret_jwt_encryption_key)
