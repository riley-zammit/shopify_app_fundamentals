require 'shopify_app'
class ApplicationController < ActionController::Base
    before_action :setup_session
    after_action :allow_iframe
    private
        def setup_session
            ShopifyApp::Session.setup(api_key: Rails.configuration.api_key, secret: Rails.configuration.api_secret)
        end

        def allow_iframe
            response.headers.except! 'X-Frame-Options'
        end
end
