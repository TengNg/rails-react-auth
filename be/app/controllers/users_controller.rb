class UsersController < ProtectedController
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
end
