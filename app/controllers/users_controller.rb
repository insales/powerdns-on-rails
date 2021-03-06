class UsersController < InheritedResources::Base
  allow_admin_only!

  def collection
    @users ||= super.reorder(email: :asc)
  end

  def update
    # strip out blank params
    params[:user].delete_if { |k,v| v.blank? }
    update!
  end

  def suspend
    resource.suspend!
    redirect_to users_path
  end

  def unsuspend
    resource.unsuspend!
    redirect_to users_path
  end

  def destroy
    resource.delete!
    redirect_to users_path
  end

  def purge
    resource.destroy
    redirect_to users_path
  end
end