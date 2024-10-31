class AuthController < ApplicationController
  before_action :set_user_from_refresh_token, only: %i[refresh logout logout_of_all_devices]

  def register
    found_user = User.find_by(username: permitted_params[:username])
    return render json: { message: 'Username is already taken' }, status: :conflict if found_user

    user = User.new(permitted_params)
    return render json: user.as_json, status: :created if user.save

    err_msg = user.errors.blank? ? 'Registration failed' : user.errors.full_messages.to_sentence
    render json: { message: err_msg }, status: :unprocessable_entity
  end

  def login
    user = User.find_by(username: permitted_params[:username])
    return render json: { message: 'User not found' }, status: :not_found if user.nil?

    if user.validate_password(password: permitted_params[:password])
      access_token = generate_access_token(user:)
      refresh_token = generate_refresh_token(user:)
      set_auth_cookies(access_token:, refresh_token:)
      return render json: { message: 'Login successful' }, status: :ok
    end

    render json: { message: 'Invalid username or password' }, status: :unauthorized
  end

  def refresh
    access_token = generate_access_token(user: @user)
    set_access_token_cookie(access_token:)
    head :ok
  rescue StandardError => e
    Rails.logger.error(e)
    render json: { message: e.message }, status: :unprocessable_entity
  end

  def logout
    delete_auth_cookies
    render json: { message: 'Logout successful' }, status: :ok
  end

  def logout_of_all_devices
    @user.update!(refresh_token_version: @user.refresh_token_version + 1)
    delete_auth_cookies
    head :ok
  end

  private

  # Get user from cookies (using refresh token value)
  def set_user_from_refresh_token
    refresh_token = cookies[rtoken_cookie_name]
    return render json: { message: 'Invalid token' }, status: :forbidden if refresh_token.nil?

    refresh_token_secret = ENV['REFRESH_TOKEN_SECRET']
    decoded_username = decoded_username(token: refresh_token, token_secret: refresh_token_secret)
    @user = User.find_by(username: decoded_username)
    render json: { message: 'User not found' }, status: :forbidden if @user.nil?
  end

  # Generate JWT access token
  # @param user [User]
  # @return [String] access token
  def generate_access_token(user:)
    payload = { username: user.username, exp: 15.minutes.from_now.to_i }
    JWT.encode(payload, ENV['ACCESS_TOKEN_SECRET'], 'HS256')
  end

  # Generate JWT refresh token
  # @param user [User]
  # @return [String] refresh token
  def generate_refresh_token(user:)
    payload = { username: user.username, exp: 1.week.from_now.to_i }
    JWT.encode(payload, ENV['REFRESH_TOKEN_SECRET'], 'HS256')
  end

  # Store tokens in secure, HttpOnly cookies
  # @param access_token [String] access token
  # @param refresh_token [String] refresh token
  def set_auth_cookies(access_token:, refresh_token:)
    set_access_token_cookie(access_token:)
    set_refresh_token_cookie(refresh_token:)
  end

  # Store access token in secure, HttpOnly cookies
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

  def permitted_params
    params.require(:auth).permit(:username, :password)
  end
end
