class ApplicationController < ActionController::API
  include ActionController::Cookies

  private

  def decoded_refresh_token_version(token:, token_secret:)
    decoded_user_data(token:, token_secret:).fetch('refresh_token_version')
  end

  def decoded_username(token:, token_secret:)
    decoded_user_data(token:, token_secret:).fetch('username')
  end

  def decoded_user_data(token:, token_secret:)
    decoded_data(token:, token_secret:, key: 'user_data')
  end

  # Get decoded data from given jwt token
  # @param token [String]
  # @param token_secret [String]
  # @param key [String] data key name
  # @return [String] decoded username
  def decoded_data(token:, token_secret:, key: nil)
    decoded = decode_token(token:, token_secret:)
    key.nil? ? decoded[0] : (decoded[0][key] || decoded[0])
  end

  # Decode jwt token
  # @param token [String]
  # @param token_secret [String]
  # @return [Hash] decoded token
  def decode_token(token:, token_secret:)
    JWT.decode(token, token_secret, true, { algorithm: 'HS256' })
  end

  # Get refresh token cookie name
  # @return [String]
  def rtoken_cookie_name
    "#{ENV['REFRESH_TOKEN_COOKIE_PREFIX'] or ''}_rtoken"
  end

  # Get access token cookie name
  # @return [String]
  def atoken_cookie_name
    "#{ENV['ACCESS_TOKEN_COOKIE_PREFIX'] or ''}_atoken"
  end
end
