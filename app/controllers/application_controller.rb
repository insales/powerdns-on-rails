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
    sign_out_and_redirect(User) if current_user && Time.now > current_user.current_sign_in_at + 18.hours
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
