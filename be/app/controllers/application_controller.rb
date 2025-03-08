class ApplicationController < ActionController::API
  include ActionController::Cookies

  rate_limit to: 50, within: 10.minute, with: -> { handle_rate_limit }

  private

  # Rate limit handler, return 429
  #
  # @param err_msg [String] custom error message
  def handle_rate_limit(err_msg = 'Too many requests, please try again later')
    render json: { message: err_msg }, status: :too_many_requests
  end

  # Get `user_data` from `decoded_data` (see #decoded_data)
  #
  # @param token [String]
  # @param token_secret [String]
  # @return [Object] decoded data
  def decoded_user_data(token:, token_secret:)
    decoded_data(token:, token_secret:, key: 'user_data')
  end

  # Get decoded data from given jwt tokens
  #
  # @param token [String]
  # @param token_secret [String]
  # @param key [String] data key name
  # @return [Object] decoded data
  def decoded_data(token:, token_secret:, key: nil)
    decoded = decoded_token(token:, token_secret:)
    return nil if decoded.nil?

    key.nil? ? decoded[0] : (decoded[0][key] || decoded[0])
  end

  # Decode jwt token
  #
  # @param token [String]
  # @param token_secret [String]
  # @return [Hash] decoded token
  def decoded_token(token:, token_secret:)
    JWT.decode(token, token_secret, true, { algorithm: 'HS256' })
  rescue JWT::DecodeError
    nil
  end

  # Get refresh token cookie name
  #
  # @return [String]
  def rtoken_cookie_name
    "#{ENV['REFRESH_TOKEN_COOKIE_PREFIX'] or ''}_rtoken"
  end

  # Get access token cookie name
  #
  # @return [String]
  def atoken_cookie_name
    "#{ENV['ACCESS_TOKEN_COOKIE_PREFIX'] or ''}_atoken"
  end

  # Generate JWT access token
  #
  # @param user [User]
  # @return [String] access token
  def generate_access_token(user:)
    payload = {
      user_data: {
        id: user.id,
        username: user.username,
        roles: user.roles.pluck(:name),
        refresh_token_version: user.refresh_token_version,
      },
      exp: 15.minutes.from_now.to_i
    }
    JWT.encode(payload, ENV['ACCESS_TOKEN_SECRET'], 'HS256')
  end

  # Generate JWT refresh token
  #
  # @param user [User]
  # @return [String] refresh token
  def generate_refresh_token(user:)
    payload = {
      user_data: {
        id: user.id,
        username: user.username,
        roles: user.roles.pluck(:name),
        refresh_token_version: user.refresh_token_version,
      },
      exp: 1.week.from_now.to_i
    }
    JWT.encode(payload, ENV['REFRESH_TOKEN_SECRET'], 'HS256')
  end

  # Store tokens in secure, HttpOnly cookies
  #
  # @param access_token [String] access token
  # @param refresh_token [String] refresh token
  def set_auth_cookies(access_token:, refresh_token:)
    set_access_token_cookie(access_token:)
    set_refresh_token_cookie(refresh_token:)
  end

  # Store access token in secure, HttpOnly cookies
  #
  # @param access_token [String] access token
  def set_access_token_cookie(access_token:)
    cookies[atoken_cookie_name] = {
      value: access_token,
      httponly: true,
      secure: true,
      same_site: :none,
      expires: 15.minutes.from_now
    }
  end

  # Store refresh token in secure, HttpOnly cookies
  #
  # @param refresh_token [String] refresh token
  def set_refresh_token_cookie(refresh_token:)
    cookies[rtoken_cookie_name] = {
      value: refresh_token,
      httponly: true,
      secure: true,
      same_site: :none,
      expires: 1.week.from_now
    }
  end

  # Delete access & refresh tokens from cookies
  def delete_auth_cookies
    delete_access_token_cookie
    delete_refresh_token_cookie
  end

  def delete_access_token_cookie
    cookies.delete(atoken_cookie_name)
  end

  def delete_refresh_token_cookie
    cookies.delete(rtoken_cookie_name)
  end
end
