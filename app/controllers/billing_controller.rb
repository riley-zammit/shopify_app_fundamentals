class BillingController < AuthenticatedController
    
    def show
        subscription = shopify_get_current_subscription()
        render(json:{plan:subscription})
    end
    
    def update
        plan = Plan.find_by(name: params[:plan])
        #activate new billing plan on Shopify
        response = shopify_update_subscription(plan)
        @shop.update(shopify_subs_id: response.data.appSubscriptionCreate.appSubscription.id)
        #redirect the merchant to Shopify to accept the charge
        redirect_to(response.data.appSubscriptionCreate.confirmationUrl)
    end

    def send_email_and_charge
        plan = @shop.plan
        monthly_emails_to_date = @shop.email_records.this_month().to_a()

        if monthly_emails_to_date.count > plan.free_email_limit
            #create a usage charge on Shopify for the email
            shopify_create_usage_charge(@shop.plan, "Email number #{}", @shop.shopify_subs_id)
        end
        #send the email
        email = stub_send_email()
        render(json: {email: email})
    end


    private
        def shopify_update_subscription(plan)
            #@shopify_gql_client instantiated in ApplicationController
            update_subscription_query = @shopify_gql_client.parse <<-'GRAPHQL'
            mutation($name: String!, $amount: Decimal!, $cappedAmount:Decimal!, $returnUrl:URL!, $trialDays:Int, $terms:String){
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
                                        amount: $cappedAmount,
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
                returnUrl: "#{Rails.configuration.app_root}?shop=#{@shop.shop_name}", 
                trialDays: plan.trial_days,
                cappedAmount: plan.capped_amount/100,
                terms: plan.description
            }

            response = @shopify_gql_client.query(update_subscription_query, variables: variables)
            return response.data
        end

        def shopify_create_usage_charge(plan, description, shopify_subscription_id)
            usage_charge_mutation = @shopify_gql_client.parse <<-'GRAPHQL'
            mutation($description:String!, $amount:Decimal!, $id:ID!){
                appUsageRecordCreate(
                    subscriptionLineItemId:$id,
                    description: $description,
                    price: {
                        amount: $amount,
                        currencyCode: USD
                    }                    
                )
                {
                    appUsageRecord{
                        id
                        subscriptionLineItem{
                            usageRecords{
                                edges{
                                    node{
                                        description
                                        createdAt
                                        price{
                                            amount
                                        }
                                    }
                                }
                            }
                        }
                    }
                    userErrors{
                        field
                        message
                    }
                }
            }
            GRAPHQL
            
            variables = {
                amount:plan.cost_monthly,
                description: description,
                id: shopify_subscription_id
            }
            resopnse = @shopify_gql_client.query(usage_charge_mutation, variables:variables)
            return response.data
        end

        def shopify_get_current_subscription
            current_subscription_query = @shopify_gql_client.parse <<-'GRAPHQL'
            query{
                currentAppInstallation{
                    activeSubscriptions{
                        name
                        currentPeriodEnd
                        trialDays
                        lineItems{
                            plan{
                                pricingDetails{
                                    ... on AppRecurringPricing{
                                    interval
                                    price{
                                        amount
                                        }
                                    }
                                }
                            }
                            usageRecords(first:10){
                                edges{
                                    node{
                                        createdAt
                                        description
                                        price{
                                            amount
                                        }
                                    }
                                }
                            }
                        }
                    }
                }
            }
            GRAPHQL
            response = @shopify_gql_client.query(current_subscription_query)
            return response.data
        end


        def stub_send_email
            #send email here
            return EmailRecord.create(sent: DateTime.now, subject:"Test email from Shopify", to:"foo@bar.com", shop: @shop)
        end

end
