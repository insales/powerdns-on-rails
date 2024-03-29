# frozen_string_literal: true

class SamlResponseGenerator
  include SamlIdp::Controller

  def saml_acs_url
    Rails.application.secrets.sso_sp_url
  end

  def call(nameId, opts = {})
    SamlIdp.configure do |config|
      config.x509_certificate = opts[:certificate] if opts[:certificate]
      config.secret_key = opts[:secret_key] if opts[:secret_key]
      config.name_id.formats = {
        email_address: -> (principal) { principal },
        # transient: -> (principal) { principal.id },
        # persistent: -> (p) { p.id },
      }
    end

    self.algorithm = :sha1
    @saml_request_id = nil
    new_opts = opts.merge(audience_uri: Rails.application.secrets.sso_sp_entity_id, issuer_uri: Rails.application.secrets.sso_idp_url)
    encode_authn_response(nameId, new_opts.except(:secret_key, :certificate))
  end
end

RSpec.describe ".create" do
  context 'when certificate is wrong' do
    let(:certificate) { 'MIIDUzCCAjsCFCzjlo9/LOP0svjsvmvIWWEWbEPKMA0GCSqGSIb3DQEBCwUAMGYxCzAJBgNVBAYTAlJVMQ8wDQYDVQQIDAZNb3Njb3cxDzANBgNVBAcMBk1vc2NvdzEQMA4GA1UECgwHSW5zYWxlczEUMBIGA1UECwwLRGV2ZWxvcG1lbnQxDTALBgNVBAMMBHRlc3QwHhcNMjEwNzEzMTY0MjEwWhcNMzEwNzE1MTY0MjEwWjBmMQswCQYDVQQGEwJSVTEPMA0GA1UECAwGTW9zY293MQ8wDQYDVQQHDAZNb3Njb3cxEDAOBgNVBAoMB0luc2FsZXMxFDASBgNVBAsMC0RldmVsb3BtZW50MQ0wCwYDVQQDDAR0ZXN0MIIBIjANBgkqhkiG9w0BAQEFAAOCAQ8AMIIBCgKCAQEA5myMYm5ZTZLyU7A+D/ThbLfnbhPfSMpEVZbvF7t+AYGykSyWW8iObtr8wr4zRYwu9LuoUOFQ5/rkYlKMPd/3Fx/vDqiuSqkyL4pglwo/7zYCxvZugVsVqd79TTFZVoFeNXAtSHDyrJmyqE6cXxd3BZ+XyM1DLLBL/bnt8vkC6/FQaVktyQUZodjwO1REW9sWLhZ5JI5xFhvb9MPtM/om8G2dRnZ86tbaq9VsLw0Bu3sJ1TC1tIsQHvptzGBs5t2ppuF/lbg7NeqRieIEKVXNLBJ4MP3YX6bm79FNn+Lyk3u8LSardexcSmBajRBWxNlOw79VC1p7Kg+8waCGbuUtAwIDAQABMA0GCSqGSIb3DQEBCwUAA4IBAQBXH6YyxrNEJg4rDr9tgWy6vsmoyTdiEypnFQiFHU35IlisSVIJ6UYuod/bVZD18pELEYVBwF6vMQ4FgLKGlomVniQWQ1yd7vkAhsCmgUehOMedAAoZqOSYUJFxUEC9BwSNXClXxz2D0BKEqmPV1m0jsz6Yb4IE7c2oyPZsHl7U7xxzmyVKYIN1XIeSSnkuBEFRE+F6zo//Y37D5O4Tq6NjF9/OA/rzmeREEx6XP6mJVhOLrmnp/PvseWOksz87W9I6IoX1tXmBqgt3BQeipTj3EaUgnKg12uUYSGtiKA7mqYzbCS0Ub5p9V/hki4coAvHE/HrkMHGrYx+eulFnmStv' }
    let(:secret_key) { "-----BEGIN RSA PRIVATE KEY-----\nMIIEogIBAAKCAQEA5myMYm5ZTZLyU7A+D/ThbLfnbhPfSMpEVZbvF7t+AYGykSyW\nW8iObtr8wr4zRYwu9LuoUOFQ5/rkYlKMPd/3Fx/vDqiuSqkyL4pglwo/7zYCxvZu\ngVsVqd79TTFZVoFeNXAtSHDyrJmyqE6cXxd3BZ+XyM1DLLBL/bnt8vkC6/FQaVkt\nyQUZodjwO1REW9sWLhZ5JI5xFhvb9MPtM/om8G2dRnZ86tbaq9VsLw0Bu3sJ1TC1\ntIsQHvptzGBs5t2ppuF/lbg7NeqRieIEKVXNLBJ4MP3YX6bm79FNn+Lyk3u8LSar\ndexcSmBajRBWxNlOw79VC1p7Kg+8waCGbuUtAwIDAQABAoIBADPC+p4577GvauRF\n2Qs4lVMY1NIzgJsXZNZdO4R3R80K15QpEfW4Tda1NsaAd4AOB5ZOeXcBxmz2PUuh\nA4P6xcTaFZeTaOO4sl9flGcZlFcmKOWNAjHoxisMvpYSmeEG2qTieCmnxbvkIvAQ\nCKyL1t7ahPxEr+xgBhIPLFbCfVeGxsxAhTBgxPybkIIKfP/xS70EqjyTuLLDqPr0\nHyZporbmPMnL+tsRvmcECBcQEaGdFC03Iu3R3B87J5s6FeIv9JOpfYuKVshvoxYw\nECPQBD/N0QbLd/Hrfy94uKUYhJWZwBtrU/dElyn7lwtAPYn/TwoRI59CyuAPmq42\nC2sjTvECgYEA9LEFK+eLz7QlB/3TdHYuQ7XmPfxECgfD0qEY4LUo3dSyu3s43TyU\nVqnGJ2r6THpuUF82ZaBxv6DwzKTqlq9iJ4jyZXnLgOOqimiV33CLf84uwLx+eWED\n2NPIasDblYwv+l6x0LAQVKtB641m+NtyfPKEfRpO9m1K34lG1ELdt1cCgYEA8RK6\nTH+cCv3LmzbO+YTQRDANU7lHxaS3nEmZIur2jEFO79f0wLOSBu7+arlto97k6E0x\n/VwuAh5pOCcv+8WoQQ3djY3BNw5bO4I0EkquRSmMM3Zd78kfnDrZe2Aaosp2rZSG\nvbkWGfCFUtBgSObZHdFdqV32TTePteygVhgoiDUCgYAIVGpfpz88L96+2eYz5b4H\ncg7Hd2n9iWwiJHfLVn9wpcf71+MErQZDuP3U47BnoBdXRxZ7+S1GH71yyf5uaMQH\nooLV74J8/cMVeR/4/kTRcfxndUM88I+H9xWwhKY0/hO4Czc0annz1+yjjym9OQM5\nu6vE8ntTqj7NQ0gU+72+ewKBgD0irrQvuHbhHf1izOJiWB6ywO52kkkBGL89uuQs\nChJPjaEtdxhXcbTobwTJuZBROmPfD8pc0h4fcDeZWIXU/nJg/cqkJFe+AEz7HBF3\ndvJ7Mt7qKbBhpO6NzhGHsbmO9sHWZMVAZuZ1JJp31bMnN/Bj5AjLl2bFrGBKfe7X\neY/xAoGASUgRtKncolb9Myph1S03T7+bbBQGkQuYTJh8fE+1d1vr3CO1OWuoCXcj\noohcTUkKFlQFqZEniPeVnfLL2VvTIYNTLXvSN5dZNH1PKe5nQvesam7ZYQf0zrBa\nmnTY7bBZN6PpxealD4aoYIXFpaX0bDRyXUyKlXXj9Dz3BvnHYLU=\n-----END RSA PRIVATE KEY-----" }

    it 'does not login' do
      post_data = SamlResponseGenerator.new.call 'developer@insales.ru', secret_key: secret_key, certificate: certificate

      expect {
        post Rails.application.secrets.sso_sp_url, params: { SAMLResponse: post_data }
      }.not_to change(User, :count)
      # expect(response).to redirect_to('/idp/auth')
    end
  end

  context 'when certificate is right' do
    let(:certificate) { 'LS0tLS1CRUdJTiBDRVJUSUZJQ0FURS0tLS0tCk1JSURxekNDQXhTZ0F3SUJBZ0lCQVRBTkJna3Foa2lHOXcwQkFRc0ZBRENCaGpFTE1Ba0dBMVVFQmhNQ1FWVXgKRERBS0JnTlZCQWdUQTA1VFZ6RVBNQTBHQTFVRUJ4TUdVM2xrYm1WNU1Rd3dDZ1lEVlFRS0RBTlFTVlF4Q1RBSApCZ05WQkFzTUFERVlNQllHQTFVRUF3d1BiR0YzY21WdVkyVndhWFF1WTI5dE1TVXdJd1lKS29aSWh2Y05BUWtCCkRCWnNZWGR5Wlc1alpTNXdhWFJBWjIxaGFXd3VZMjl0TUI0WERURXlNRFF5T0RBeU1qSXlPRm9YRFRNeU1EUXkKTXpBeU1qSXlPRm93Z1lZeEN6QUpCZ05WQkFZVEFrRlZNUXd3Q2dZRFZRUUlFd05PVTFjeER6QU5CZ05WQkFjVApCbE41Wkc1bGVURU1NQW9HQTFVRUNnd0RVRWxVTVFrd0J3WURWUVFMREFBeEdEQVdCZ05WQkFNTUQyeGhkM0psCmJtTmxjR2wwTG1OdmJURWxNQ01HQ1NxR1NJYjNEUUVKQVF3V2JHRjNjbVZ1WTJVdWNHbDBRR2R0WVdsc0xtTnYKYlRDQm56QU5CZ2txaGtpRzl3MEJBUUVGQUFPQmpRQXdnWWtDZ1lFQXVCeXdQTmxDMUZvcEdMWWZGOTZTb3RpSwo4Tmo2L25XMDg0TzRvbVJNaWZ6eTd4OTU1UkxFeTY3M3EyYWlKTkIzTHZFNlh2a3Q5Y0d0eHROb09YdzFnMlV2CkhLcGxkUWJyNmJPRWpMTmVETlc3ajBvYitKclJ2QVVPSzlDUmdkeXc1TUM2bHdxVlFRNUMxRG5hVC8yZlNCRmoKYXNCRlRSMjRkRXBmVHk4SGZLRUNBd0VBQWFPQ0FTVXdnZ0VoTUFrR0ExVWRFd1FDTUFBd0N3WURWUjBQQkFRRApBZ1VnTUIwR0ExVWREZ1FXQkJRTkJHbW10M3l0S3BjSmFCYVlOYm55VTJ4a2F6QVRCZ05WSFNVRUREQUtCZ2dyCkJnRUZCUWNEQVRBZEJnbGdoa2dCaHZoQ0FRMEVFQllPVkdWemRDQllOVEE1SUdObGNuUXdnYk1HQTFVZEl3U0IKcXpDQnFJQVVEUVJwcHJkOHJTcVhDV2dXbURXNThsTnNaR3VoZ1l5a2dZa3dnWVl4Q3pBSkJnTlZCQVlUQWtGVgpNUXd3Q2dZRFZRUUlFd05PVTFjeER6QU5CZ05WQkFjVEJsTjVaRzVsZVRFTU1Bb0dBMVVFQ2d3RFVFbFVNUWt3CkJ3WURWUVFMREFBeEdEQVdCZ05WQkFNTUQyeGhkM0psYm1ObGNHbDBMbU52YlRFbE1DTUdDU3FHU0liM0RRRUoKQVF3V2JHRjNjbVZ1WTJVdWNHbDBRR2R0WVdsc0xtTnZiWUlCQVRBTkJna3Foa2lHOXcwQkFRc0ZBQU9CZ1FBRQpjVlVQQlg3dVptenFaSmZ5K3RVUE9UNUltTlFqOFZFMmxlcmhuRmpuR1BIbUhJcWhwemdud0hRdWpKZnMvYTMwCjlXbTVxd2NDYUMxZU81Y1dqY0cweDNPamRsbHNnWURhdGw1R0F1bXRCeDhKM05oV1JxTlVnaXRDSWtRbHhISXcKVWZnUWFDdXNoWWdEREw1WWJJUWErK2VnQ2dwSVorVDBEajVvUmV3Ly9BPT0KLS0tLS1FTkQgQ0VSVElGSUNBVEUtLS0tLQo=' }
    let(:secret_key) { "-----BEGIN RSA PRIVATE KEY-----\nMIICXAIBAAKBgQC4HLA82ULUWikYth8X3pKi2Irw2Pr+dbTzg7iiZEyJ/PLvH3nl\nEsTLrverZqIk0Hcu8Tpe+S31wa3G02g5fDWDZS8cqmV1Buvps4SMs14M1buPShv4\nmtG8BQ4r0JGB3LDkwLqXCpVBDkLUOdpP/Z9IEWNqwEVNHbh0Sl9PLwd8oQIDAQAB\nAoGAQmUGIUtwUEgbXe//kooPc26H3IdDLJSiJtcvtFBbUb/Ik/dT7AoysgltA4DF\npGURNfqERE+0BVZNJtCCW4ixew4uEhk1XowYXHCzjkzyYoFuT9v5SP4cu4q3t1kK\n51JF237F0eCY3qC3k96CzPGG67bwOu9EeXAu4ka/plLdsAECQQDkg0uhR/vsJffx\ntiWxcDRNFoZpCpzpdWfQBnHBzj9ZC0xrdVilxBgBpupCljO2Scy4MeiY4S1Mleel\nCWRqh7RBAkEAzkIjUnllEkr5sjVb7pNy+e/eakuDxvZck0Z8X3USUki/Nm3E/GPP\nc+CwmXR4QlpMpJr3/Prf1j59l/LAK9AwYQJBAL9eRSQYCJ3HXlGKXR6v/NziFEY7\noRTSQdIw02ueseZ8U89aQpbwFbqsclq5Ny1duJg5E7WUPj94+rl3mCSu6QECQBVh\n0duY7htpXl1VHsSq0H6MmVgXn/+eRpaV9grHTjDtjbUMyCEKD9WJc4VVB6qJRezC\ni/bT4ySIsehwp+9i08ECQEH03lCpHpbwiWH4sD25l/z3g2jCbIZ+RTV6yHIz7Coh\ngAbBqA04wh64JhhfG69oTBwqwj3imlWF8+jDzV9RNNw=\n-----END RSA PRIVATE KEY-----" }

    it 'logins' do
      post_data = SamlResponseGenerator.new.call('developer@insales.ru', secret_key: secret_key, certificate: certificate)

      expect {
        post Rails.application.secrets.sso_sp_url, params: { SAMLResponse: post_data }
      }.to change(User, :count).by(1)
      expect(response).to redirect_to('/')
    end
  end
end
