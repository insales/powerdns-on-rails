# frozen_string_literal: true

class Devise::SamlSessionsFixedController < Devise::SamlSessionsController
  def _url_host_allowed?(url)
    redirect_host = URI(url.to_s).host
    redirect_host == request.host || redirect_host == URI(Rails.application.secrets.sso_idp_url).host
  rescue ArgumentError, URI::Error
    false
  end
end