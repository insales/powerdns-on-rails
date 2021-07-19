class FakeIdpController < ActionController::Base
  include SamlIdp::Controller unless Rails.env.production?

  def create
    raise "Not for production" if Rails.env.production?

    validate_saml_request
    @saml_response = encode_SAMLResponse 'developer@insales.ru', audience_uri: 'http://localhost:3000/users/saml/metadata', issuer_uri: 'http://localhost:3000/idp/auth'
    render template: "saml_idp/idp/saml_post", layout: false
  end
end