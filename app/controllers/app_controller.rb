
class AppController < ApplicationController
  before_action :authenticate_shopify_request

  def index
  
    if !existing_installation()
      if new_auth_flow?()
        redirect_to controller: 'oauth', action: 'authenticate', shop: params[:shop], timestamp: params[:timestamp], hmac: params[:hmac] and return
      else
        complete_oauth_flow()
      end
    end

    @shop=Shop.find_by(shop_name: params[:shop])
    @shop_origin = @shop.shop_name
    @api_key = Rails.configuration.api_key
    @plans = Plan.all
    #automatically renders index.html
  end

  private
    def existing_installation
      Shop.exists?(shop_name: params[:shop])
    end

    #------Helper methods to complete the oauth flow-------
    def complete_oauth_flow
      if auth_session_valid?()
        token = @shopify_session.request_token(params)
        plan = Plan.find_by name:"free-plan"
        @shop = Shop.create(token: token, shop_name: params[:shop], plan_name:'free-plan', plan:plan)
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
