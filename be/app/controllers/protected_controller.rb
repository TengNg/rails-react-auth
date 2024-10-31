class ProtectedController < ApplicationController
  before_action :authenticate_token

  # Authenticate access token from cookies
  def authenticate_token
    access_token = cookies[atoken_cookie_name]
    access_token_secret = ENV['ACCESS_TOKEN_SECRET']
    decoded_username = decoded_username(token: access_token, token_secret: access_token_secret)
    @user = User.find_by(username: decoded_username)
    render json: { message: 'User not found' }, status: :unauthorized if @user.nil?
  rescue StandardError => e
    Rails.logger.error(e)
    render json: { message: 'Authentication Error' }, status: :unauthorized
  end
end
