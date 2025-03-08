class AuthController < ApplicationController
  rate_limit(
    to: 10,
    within: 1.minute,
    only: [ :login, :register ],
    with: -> { handle_rate_limit }
  )

  def register
    found_user = User.find_by(username: permitted_params[:username])
    return render json: { message: 'Username is already taken' }, status: :conflict if found_user

    user = User.new(permitted_params)
    if user.save
      Rails.logger.info("User[id=#{user.id}; username:#{user.username}] registered")
      return render json: user.as_json, status: :created
    end

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
      Rails.logger.info("User[id=#{user.id}; username:#{user.username}] logged in")
      return head :ok
    end

    render json: { message: 'Invalid username or password' }, status: :unauthorized
  end

  # def refresh
  #   access_token = generate_access_token(user: @user)
  #   set_access_token_cookie(access_token:)
  #   head :ok
  # rescue
  #   Rails.logger.error(e)
  #   render json: { message: e.message }, status: :unprocessable_entity
  # end

  private

  def permitted_params
    params.require(:auth).permit(:username, :password)
  end
end
