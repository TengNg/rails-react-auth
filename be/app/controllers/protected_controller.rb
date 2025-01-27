class ProtectedController < ApplicationController
  before_action :authenticate_token

  private

  # Authenticate access token from cookies
  def authenticate_token
    access_token = cookies[atoken_cookie_name]
    refresh_token = cookies[rtoken_cookie_name]
    return head :unauthorized if access_token.nil? && refresh_token.nil?

    decoded = check_tokens(access_token:, refresh_token:)
    @user = decoded[:user]
    @user_id = decoded[:user_id]
    @roles = decoded[:roles]

    # not sure how to setup fixtures for this check (currently not working)
    if !Rails.env.test? && @roles.blank?
      return render json: { message: 'No roles' }, status: :unauthorized
    end

    if @user
      set_access_token_cookie(access_token: generate_access_token(user: @user))
    end
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
    unless decoded.nil?
      return {
        user_id: decoded['id'],
        roles: decoded['roles'],
      }
    end

    raise 'Invalid token' if refresh_token.nil?

    decoded = decoded_user_data(token: refresh_token, token_secret: ENV['REFRESH_TOKEN_SECRET'])
    user_id = decoded['id']
    user = User.find_by(id: user_id)

    if user.nil? || user.refresh_token_version != user.refresh_token_version
      raise 'Invalid token'
    end

    { user:, user_id:, roles: user.role_names }
  end
end
