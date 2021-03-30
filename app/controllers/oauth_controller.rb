class OauthController < ApplicationController
    before_action :setup_shopify_session
    def authenticate
        @shop_name = params[:shop]
        timestamp = params[:timestamp]
        hmac = params[:hmac]

        #save authentication state
        my_nonce = Nonce.create(shop_name: @shop_name, nonce: nonce())

        #create a url for the merchant to grant your app access to their store's data. Redirect to redirect_url when merchant accepts
        scope = Rails.configuration.scope
        #gets passed to the html view so app bridge can redirect
        @accept_permissions_url = @shopify_session.create_permission_url(scope, Rails.configuration.app_root, {state: my_nonce.nonce})
        @api_key = Rails.configuration.api_key

        #in an embedded app, you need to redirect on the front end by using app bridge
        render :front_end_redirect, layout:false
    end

private

    def nonce
        #random 30-char nonce
        rand(10 ** 30).to_s.rjust(30, '0')
    end
end
