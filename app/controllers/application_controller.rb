require 'shopify_api'
require 'openssl'
class ApplicationController < ActionController::Base
    
    after_action :allow_iframe


    private

        def setup_shopify_session
            ShopifyAPI::Session.setup(api_key: Rails.configuration.api_key, secret: Rails.configuration.api_secret)
            @shopify_session = ShopifyAPI::Session.new(domain: params[:shop], api_version: Rails.configuration.api_version, token:nil)
        end
    
        #---methods to validate requests from shopify-----
        def authenticate_shopify_request
            unless hmac_valid?()
                unauthorized() and return
            end
        end
    
        def hmac_valid?
            #remove hmac value from the params array and recreate string in form "timestamp=12345&shop=test.myshopify.com..."
            parameters = request.query_parameters().to_hash().map{|key, value|  "#{key}=#{value}" if key != 'hmac'}.filter{|val| !val.nil?}
            params_string = parameters.join("&")

            secret = Rails.configuration.api_secret
            computed_hmac = OpenSSL::HMAC.hexdigest('sha256', secret, params_string)
            ActiveSupport::SecurityUtils.secure_compare(computed_hmac, params[:hmac])
        end

        #----------------misc utility methods------------
        #allow app to be embedded in Shopify admin by removing x-frame-options header
        def allow_iframe
            response.headers.except!('X-Frame-Options')
        end

        def unauthorized
            render(file: "public/401.html", status: :unauthorized)
        end

        #-----authenticated methods------
        def activate_shopify_session
            unless @shop
                unauthorized()
            else
                version = Rails.configuration.api_version
                @shopify_session = ShopifyAPI::Session.new(domain: @shop.shop_name, token: @shop.token, api_version: version)
                ShopifyAPI::Base.activate_session(@shopify_session)                
                #remember to dump the schema with rake shopify_api:graphql:dump SHOP_DOMAIN=SHOP_NAME.myshopify.com ACCESS_TOKEN=abc API_VERSION=2021-01 or this call will fail
                @shopify_gql_client = ShopifyAPI::GraphQL.client
                debug=0  
            end
            
        end
    
end
