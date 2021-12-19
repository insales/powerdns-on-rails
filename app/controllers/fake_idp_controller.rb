class FakeIdpController < ActionController::Base
  include SamlIdp::Controller unless Rails.env.production?

  def saml_acs_url
    Rails.application.secrets.sso_sp_url
  end

  def create
    raise "Not for production" if Rails.env.production?

    # not thread-safe, but will do in development
    SamlIdp.configure do |config|
      config.name_id.formats = { email_address: -> (principal) { principal } }
    end

    # FIXME: enable validation
    # validate_saml_request

    @saml_response = encode_response 'developer@insales.ru',
      audience_uri: Rails.application.secrets.sso_sp_entity_id,
      issuer_uri: Rails.application.secrets.sso_idp_url

    render inline: <<~ERB, layout: false unless performed?
      <!DOCTYPE html>
      <html>
        <head>
          <meta charset="utf-8">
          <meta http-equiv="X-UA-Compatible" content="IE=edge,chrome=1">
        </head>
        <body onload="document.forms[0].submit();" style="visibility:hidden;">
          <%= form_tag(saml_acs_url) do %>
            <%= hidden_field_tag("SAMLResponse", @saml_response) %>
            <%= hidden_field_tag("RelayState", params[:RelayState]) %>
            <%= submit_tag "Submit" %>
          <% end %>
        </body>
      </html>
    ERB
  end
end