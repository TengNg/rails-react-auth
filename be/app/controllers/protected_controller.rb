class ProtectedController < ApplicationController
  before_action :authenticate_token

  private

  # Authenticate access token from cookies
  def authenticate_token
    access_token = cookies[atoken_cookie_name]
    refresh_token = cookies[rtoken_cookie_name]
    return head :unauthorized if access_token.nil? && refresh_token.nil?

    @user = check_tokens(access_token:, refresh_token:)
    set_access_token_cookie(access_token: generate_access_token(user: @user))
  rescue StandardError => e
    Rails.logger.error(e)
    render json: { message: e.message }, status: :unauthorized
  end

  # Verify auth tokens
  #
  # @param [String] access_token
  # @param [String] refresh_token
  # @return [User]
  def check_tokens(access_token:, refresh_token:)
    decoded = decoded_user_data(token: access_token, token_secret: ENV['ACCESS_TOKEN_SECRET'])
    user = User.find_by(id: decoded['id'])
    return user if user.present?

    raise 'Invalid token' if refresh_token.nil?

    decoded = decoded_user_data(token: refresh_token, token_secret: ENV['REFRESH_TOKEN_SECRET'])
    user_id, refresh_token_version = decoded.values_at('id', 'refresh_token_version')
    user = User.find(user_id) # raise error here if user is not found

    raise 'Invalid token' if user.refresh_token_version != refresh_token_version

    user
  end
end
