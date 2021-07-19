# Use this hook to configure devise mailer, warden hooks and so forth. The first
# four configuration values can also be set straight in your models.
Devise.setup do |config|
  # ==> Mailer Configuration
  # Configure the e-mail address which will be shown in DeviseMailer.
  config.mailer_sender = "powerdnsonrails@insales.com"

  # Configure the class responsible to send e-mails.
  # config.mailer = "Devise::Mailer"

  # ==> ORM configuration
  # Load and configure the ORM. Supports :active_record (default) and
  # :mongoid (bson_ext recommended) by default. Other ORMs may be
  # available as additional gems.
  require 'devise/orm/active_record'

  # ==> Configuration for any authentication mechanism
  # Configure which keys are used when authenticating an user. By default is
  # just :email. You can configure it to use [:username, :subdomain], so for
  # authenticating an user, both parameters are required. Remember that those
  # parameters are used only when authenticating and not when retrieving from
  # session. If you need permissions, you should implement that in a before filter.
  # config.authentication_keys = [ :email ]

  # Tell if authentication through request.params is enabled. True by default.
  # config.params_authenticatable = true

  # Tell if authentication through HTTP Basic Auth is enabled. False by default.
  config.http_authenticatable = true

  # Set this to true to use Basic Auth for AJAX requests.  True by default.
  # config.http_authenticatable_on_xhr = true

  # The realm used in Http Basic Authentication
  config.http_authentication_realm = "PowerDNS"

  # ==> Configuration for :database_authenticatable
  # For bcrypt, this is the cost for hashing the password and defaults to 10. If
  # using other encryptors, it sets how many times you want the password re-encrypted.
  config.stretches = 1

  # Define which will be the encryption algorithm. Devise also supports encryptors
  # from others authentication tools as :clearance_sha1, :authlogic_sha512 (then
  # you should set stretches above to 20 for default behavior) and :restful_authentication_sha1
  # (then you should set stretches to 10, and copy REST_AUTH_SITE_KEY to pepper)
  config.encryptor = :restful_authentication_sha1

  # Setup a pepper to generate the encrypted password.
  config.pepper = "" #"f0c822c4f45b7677c1e78715f022f4a7a83a0fa8620230b8aa92493c83c8d0c83c3075499863e05be7d5730ad0106540d3985b252ab46aa59ffc7960c64f167a"

  # Configguration for Devise SAML authentication

  # Create user if the user does not exist. (Default is false)
  config.saml_create_user = true

  # Update the attributes of the user after a successful login. (Default is false)
  config.saml_update_user = true

  # Set the default user key. The user will be looked up by this key. Make
  # sure that the Authentication Response includes the attribute.
  config.saml_default_user_key = :email

  # Optional. This stores the session index defined by the IDP during login.  If provided it will be used as a salt
  # for the user's session to facilitate an IDP initiated logout request.
  # config.saml_session_index_key = :session_index

  # You can set this value to use Subject or SAML assertation as info to which email will be compared.
  # If you don't set it then email will be extracted from SAML assertation attributes.
  config.saml_use_subject = true

  config.saml_update_resource_hook = ->(user, response, auth_value) {
    user.login = response.raw_response.nameid.downcase
    user.admin = true
    user.password = SecureRandom.hex unless user.persisted?
    Devise.saml_default_update_resource_hook.call(user, response, auth_value)
  }

  # You can support multiple IdPs by setting this value to the name of a class that implements a ::settings method
  # which takes an IdP entity id as an argument and returns a hash of idp settings for the corresponding IdP.
  # config.idp_settings_adapter = "MyIdPSettingsAdapter"

  # You provide you own method to find the idp_entity_id in a SAML message in the case of multiple IdPs
  # by setting this to the name of a custom reader class, or use the default.
  # config.idp_entity_id_reader = "DeviseSamlAuthenticatable::DefaultIdpEntityIdReader"

  # You can set a handler object that takes the response for a failed SAML request and the strategy,
  # and implements a #handle method. This method can then redirect the user, return error messages, etc.
  # config.saml_failed_callback = nil

  # You can customize the named routes generated in case of named route collisions with
  # other Devise modules or libraries. Set the saml_route_helper_prefix to a string that will
  # be appended to the named route.
  # If saml_route_helper_prefix = 'saml' then the new_user_session route becomes new_saml_user_session
  # config.saml_route_helper_prefix = 'saml'

  # You can add allowance for clock drift between the sp and idp.
  # This is a time in seconds.
  # config.allowed_clock_drift_in_seconds = 0

  # In SAML responses, validate that the identity provider has included an InResponseTo
  # header that matches the ID of the SAML request. (Default is false)
  # config.saml_validate_in_response_to = false

  # Configure with your SAML settings (see ruby-saml's README for more information: https://github.com/onelogin/ruby-saml).
  config.saml_configure do |settings|
    settings.sp_entity_id                       = 'http://localhost:3000/users/saml/metadata'
    settings.assertion_consumer_service_url     = 'http://localhost:3000/users/saml/auth'
    settings.assertion_consumer_service_binding = 'urn:oasis:names:tc:SAML:2.0:bindings:HTTP-POST'
    settings.name_identifier_format             = 'urn:oasis:names:tc:SAML:1.1:nameid-format:emailAddress'
    # settings.authn_context                      = ''

    if Rails.env.production?
      settings.idp_entity_id                    = Rails.application.secrets.sso_entity_id
      settings.idp_sso_service_url              = Rails.application.secrets.sso_url
      settings.idp_cert                         = Rails.application.secrets.sso_certificate
    else
      settings.idp_entity_id                    = 'http://localhost:3000/idp/auth'
      settings.idp_sso_target_url               = 'http://localhost:3000/idp/auth'
      settings.idp_cert_fingerprint             = '9E:65:2E:03:06:8D:80:F2:86:C7:6C:77:A1:D9:14:97:0A:4D:F4:4D'
      settings.idp_cert_fingerprint_algorithm   = XMLSecurity::Document::SHA1
    end

    settings.security[:authn_requests_signed]   = true
    settings.security[:logout_requests_signed]  = true
    settings.security[:logout_responses_signed] = true
    settings.security[:want_assertions_signed]  = true 
    settings.security[:metadata_signed]         = true
    settings.security[:digest_method]           = XMLSecurity::Document::SHA256
    settings.security[:signature_method]        = XMLSecurity::Document::RSA_SHA256
  end

  # ==> Configuration for :confirmable
  # The time you want to give your user to confirm his account. During this time
  # he will be able to access your application without confirming. Default is nil.
  # When confirm_within is zero, the user won't be able to sign in without confirming. 
  # You can use this to let your user access some features of your application 
  # without confirming the account, but blocking it after a certain period 
  # (ie 2 days). 
  # config.confirm_within = 2.days

  # ==> Configuration for :rememberable
  # The time the user will be remembered without asking for credentials again.
  # config.remember_for = 2.weeks

  # If true, a valid remember token can be re-used between multiple browsers.
  # config.remember_across_browsers = true

  # If true, extends the user's remember period when remembered via cookie.
  # config.extend_remember_period = false

  # ==> Configuration for :validatable
  # Range for password length
  # config.password_length = 6..20

  # Regex to use to validate the email address
  # config.email_regexp = /\A([\w\.%\+\-]+)@([\w\-]+\.)+([\w]{2,})\z/i

  # ==> Configuration for :timeoutable
  # The time you want to timeout the user session without activity. After this
  # time the user will be asked for credentials again.
  # config.timeout_in = 10.minutes

  # ==> Configuration for :lockable
  # Defines which strategy will be used to lock an account.
  # :failed_attempts = Locks an account after a number of failed attempts to sign in.
  # :none            = No lock strategy. You should handle locking by yourself.
  # config.lock_strategy = :failed_attempts

  # Defines which strategy will be used to unlock an account.
  # :email = Sends an unlock link to the user email
  # :time  = Re-enables login after a certain amount of time (see :unlock_in below)
  # :both  = Enables both strategies
  # :none  = No unlock strategy. You should handle unlocking by yourself.
  # config.unlock_strategy = :both

  # Number of authentication tries before locking an account if lock_strategy
  # is failed attempts.
  # config.maximum_attempts = 20

  # Time interval to unlock the account if :time is enabled as unlock_strategy.
  # config.unlock_in = 1.hour

  # ==> Configuration for :token_authenticatable
  # Defines name of the authentication token params key
  # config.token_authentication_key = :auth_token

  # ==> Scopes configuration
  # Turn scoped views on. Before rendering "sessions/new", it will first check for
  # "users/sessions/new". It's turned off by default because it's slower if you
  # are using only default views.
  # config.scoped_views = true

  # Configure the default scope given to Warden. By default it's the first
  # devise role declared in your routes.
  # config.default_scope = :user

  # Configure sign_out behavior. 
  # By default sign_out is scoped (i.e. /users/sign_out affects only :user scope).
  # In case of sign_out_all_scopes set to true any logout action will sign out all active scopes.
  # config.sign_out_all_scopes = false

  # ==> Navigation configuration
  # Lists the formats that should be treated as navigational. Formats like
  # :html, should redirect to the sign in page when the user does not have
  # access, but formats like :xml or :json, should return 401.
  # If you have any extra navigational formats, like :iphone or :mobile, you
  # should add them to the navigational formats lists. Default is [:html]
  # config.navigational_formats = [:html, :iphone]

  # ==> Warden configuration
  # If you want to use other strategies, that are not (yet) supported by Devise,
  # you can configure them inside the config.warden block. The example below
  # allows you to setup OAuth, using http://github.com/roman/warden_oauth
  #
  # config.warden do |manager|
  #   manager.oauth(:twitter) do |twitter|
  #     twitter.consumer_secret = <YOUR CONSUMER SECRET>
  #     twitter.consumer_key  = <YOUR CONSUMER KEY>
  #     twitter.options :site => 'http://twitter.com'
  #   end
  #   manager.default_strategies(:scope => :user).unshift :twitter_oauth
  # end
end
