class Admin::TestController < ProtectedController
  before_action :validate_admin!

  def test
    render json: { ok: true }
  end

  private

  def validate_admin!
    @is_admin = @roles.include?('admin')

    return render(
      json: { message: 'Not found' },
      status: :not_found
    ) unless @is_admin
  end
end
