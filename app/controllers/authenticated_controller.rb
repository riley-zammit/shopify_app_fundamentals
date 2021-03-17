require 'jwt'
class AuthenticationError < StandardError
end

class AuthenticatedController < ApplicationController
    before_action :authenticate_user_request, :activate_shopify_session
    rescue_from AuthenticationError, with: :unauthorized
    private
        def authenticate_user_request
            token = request.headers['Authorization'].split(" ").last
            expected_aud = Rails.configuration.api_key
            begin
                decoded_jwt = JWT.decode token, Rails.configuration.api_secret, true, {algorithm:'HS256', aud: expected_aud, verify_aud:true}
            rescue JWT::ExpiredSignature => e
                raise AuthenticationError("Signature has expired")
            rescue JWT::ImmatureSignature
                raise AuthenticationError("Signature is immature")
            rescue JWT::InvalidAudError
                raise AuthenticationError("Audience is invalid")
            end
            
            #manually validate non-spec field
            dest = decoded_jwt[0]['dest'] 
            iss = decoded_jwt[0]['iss'] 
            dest_tld = dest.split('/').last
            iss_tld = iss.split('/').detect{|e| e.end_with?(".myshopify.com")}
            unless dest_tld == iss_tld
                raise AuthenticationError("top level domains don't match!")
            end
            @shop = Shop.find_by shop_name: dest_tld
        end
end
