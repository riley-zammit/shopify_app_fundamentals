require 'jwt'
class AuthenticatedController < ApplicationController
    before_action :authenticate_user_request
    private
        def authenticate_user_request
            token = request.headers['Authorization'].split(" ").last
            expected_aud = Rails.configuration.api_key
            begin
                decoded_jwt = JWT.decode token, Rails.configuration.api_secret, true, {algorithm:'HS256', aud: expected_aud, verify_aud:true}
                # decoded_jwt = JWT.decode token, Rails.configuration.api_secret, false, {algorithm: 'HS256'}
            rescue JWT::ExpiredSignature => e
                raise "Signature has expired!"
            rescue JWT::ImmatureSignature
                raise "Signature is immature"
            rescue JWT::InvalidAudError
                raise "Audience is invalid"
            end
            
            #manually validate non-spec field
            dest = decoded_jwt[0]['dest'] #https://rileyzamit.myshopify.com
            iss = decoded_jwt[0]['iss'] #https://rileyzammit.myshopify.com/admin
            dest_tld = dest.split('/').last
            iss_tld = iss.split('/').detect{|e| e.end_with?(".myshopify.com")}
            unless dest_tld == iss_tld
                raise "top level domains don't match!"
            end
            
        end
end
