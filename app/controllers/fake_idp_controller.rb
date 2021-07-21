class FakeIdpController < ActionController::Base
  include SamlIdp::Controller unless Rails.env.production?

  def create
    raise "Not for production" if Rails.env.production?

    validate_saml_request
    @saml_response = encode_SAMLResponse 'developer@insales.ru', audience_uri: Rails.application.secrets.sso_sp_entity_id, issuer_uri: Rails.application.secrets.sso_idp_url
    render template: "saml_idp/idp/saml_post", layout: false
  end
end