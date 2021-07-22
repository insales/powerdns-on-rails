class ApplicationController < ActionController::Base
  protect_from_forgery

  # All pages require a login...
  before_action :authenticate_user!

  helper_method :current_token
  helper_method :token_user?

  class << self
    def allow_admin_only!
      before_action do
        redirect_to root_url unless current_user.admin?
      end
    end
  end

  def authenticate_user!
    if current_user && Time.now > current_user.current_sign_in_at + 18.hours
      current_user.current_sign_in_at = Time.now
      current_user.save
      redirect_to destroy_user_session_path
    end
    return super
  end

  protected
    # stubs
    def current_token
      nil
    end

    def token_user?
      false
    end
end
