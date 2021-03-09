
class AppController < ApplicationController
  before_action :authenticate_request
  def index

    if new_auth_flow?()
      redirect_to controller: 'oauth', action: 'authenticate', shop: params[:shop], timestamp: params[:timestamp], hmac: params[:hmac] and return
    elsif !existing_installation()
      complete_oauth_flow()
    end

    @shop_origin = @shop.shop_name
    @api_key = Rails.configuration.api_key
    
    #automatically renders index
  end

  private
    def existing_installation
      @shop = Shop.find_by(shop_name: params[:shop])
      if @shop
        return true
      end
      false
    end

    #------Helper methods to complete the oauth flow-------
    def complete_oauth_flow
      if auth_session_valid?()
        token = @shopify_session.request_token(params)
        @shop = Shop.create(token: token, shop_name: params[:shop])
        Nonce.find_by(shop_name:@shop.shop_name).update is_complete:true
      end
    end

    def auth_session_valid?
      nonce = Nonce.find_by(nonce: params[:state])
      nonce && !nonce.is_complete && shop_name_valid?() && hmac_valid?()
    end

    def new_auth_flow?
      !Nonce.exists?(nonce: params[:state])
    end

    def shop_name_valid?
      params[:shop].match(/\A[a-zA-Z0-9][a-zA-Z0-9\-]*\.myshopify\.com\z/)
    end
    
end
