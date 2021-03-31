
class AppController < ApplicationController
  before_action :authenticate_shopify_request, except: :billing_plan_accepted

  def index
  
    if !existing_installation()
      setup_shopify_session()
      if new_auth_flow?()
        redirect_to controller: 'oauth', action: 'authenticate', shop: params[:shop], timestamp: params[:timestamp], hmac: params[:hmac] and return
      else
        complete_oauth_flow()
        activate_shopify_session()
        subscription_approval_url = activate_default_subscription()
        redirect_to(subscription_approval_url) and return
      end
    end

    @shop=Shop.find_by(shop_name: params[:shop])
    @shop_origin = @shop.shop_name
    @api_key = Rails.configuration.api_key
    @plans = Plan.all
    
    render(:index)
  end

  def billing_plan_accepted
    charge_id = params[:charge_id]
    @shop = Shop.find_by(shop_name: params[:shop])
    @shop_origin = @shop.shop_name
    @api_key = Rails.configuration.api_key
    @plans = Plan.all

    render(:index)
  end

  private
    def activate_default_subscription
      plan = Plan.find_by(default_plan: true)
      create_subscription_query = @shopify_gql_client.parse <<-'GRAPHQL'
        mutation($name: String!, $amount: Decimal!, $cappedAmount:Decimal!, $returnUrl:URL!, $trialDays:Int, $terms:String) {
                appSubscriptionCreate(
                    test:true,
                    name: $name,
                    lineItems: [
                        {
                            plan:{
                                appRecurringPricingDetails:{
                                interval:EVERY_30_DAYS,
                                price:{
                                    amount: $amount,
                                    currencyCode: USD
                                    }
                                }
                            }
                        },
                        {
                            plan:{
                                appUsagePricingDetails:{
                                    cappedAmount:{
                                        amount:$cappedAmount,
                                        currencyCode: USD
                                    }
                                    terms:$terms
                                }
                            }
                        }
                    ]
                    returnUrl: $returnUrl,
                    trialDays: $trialDays
                ){
                    appSubscription{
                        id
                    }
                    confirmationUrl
                    userErrors{
                        field
                        message
                    }
                }
            }
      GRAPHQL

      variables = {
        name: plan.name, 
        amount: plan.cost_monthly, 
        returnUrl: Rails.configuration.app_root, 
        trialDays: plan.trial_days,
        cappedAmount:plan.capped_amount/100,
        terms: plan.description
      }

      response = @shopify_gql_client.query(create_subscription_query, variables: variables)
      if response.data.app_subscription_create.user_errors.length == 0
        return response.data.app_subscription_create.confirmation_url
      else
        raise "Error(s): #{response.data.app_subscription_create.user_errors.join(", ")}"
      end
    end

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
