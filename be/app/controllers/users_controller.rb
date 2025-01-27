class UsersController < ProtectedController
  before_action :set_user, except: %i[show_by_username]

  def current
    render json: @user.as_json
  end

  def show_by_username
    found_user = User.find_by(username: params[:username])
    if found_user.nil?
      err_msg = "User with username #{params[:username]} not found"
      return render json: { message: err_msg }, status: :not_found
    end

    render json: found_user.as_json
  end

  def logout
    delete_auth_cookies
    Rails.logger.info("User[id=#{@user.id}; username:#{@user.username}] logged out")
    head :ok
  rescue StandardError => e
    Rails.logger.error("users#log_out: #{e.message}")
    head :unprocessable_entity
  end

  def logout_of_all_devices
    delete_auth_cookies
    @user.update!(refresh_token_version: @user.refresh_token_version + 1)
    Rails.logger.info("User[id=#{@user.id}; username:#{@user.username}] logged out of all devices")
    head :ok
  rescue StandardError => e
    Rails.logger.info("users#log_out_of_all_devices: #{e.message}")
    head :unprocessable_entity
  end

  private

  def set_user
    return @user if @user

    @user = User.find_by(id: @user_id)
    render json: { message: 'User not found' }, status: :not_found if @user.nil?
  end
end
