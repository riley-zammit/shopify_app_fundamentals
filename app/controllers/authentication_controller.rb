class AuthenticationController < ApplicationController
    #using shopify_api gem: https://github.com/shopify/shopify_api

    def authenticate
        #'shop' parameter is passed in the query string on app load
        shop_name = params[:shop]
        shopify_session = ShopifyAPI::Session.new(domain: "#{shop_name}.myshopify.com", api_version: Rails.configuration.api_version, token:nil)

        #create a url for the merchant to grant your app access to their store's data. Redirect to redirect_url once complete
        redirect_url = Rails.configuration.app_root
        scope = Rails.configuration.scope
        #gets passed to the html view so app bridge can redirect
        @accept_permissions_url = shopify_session.create_permission_url(scope, redirect_url, {state: nonce()})

        render :authenticate
    end

    private
        def nonce
            #random 30-char nonce
            rand(10 ** 30).to_s.rjust(30, '0')
        end
end
