class BillingController < AuthenticatedController
    
    #show shop's current plan
    def show
        
        plan = shopify_get_current_subscription()
        render json:{plan:plan}
    end
    
    #change plan
    def update
        plan = Plan.find_by(name: params[:plan])
        #activate new billing plan on Shopify
        shopify_update_subscription(plan)
        render json: {plan:plan}
    end

    #email sent
    def send_email_and_charge
        plan = @shop.plan
        monthly_emails_to_date = @shop.email_records.this_month().to_a()

        if monthly_emails_to_date.count > plan.free_email_limit
            #create a usage charge on Shopify for the email
            shopify_create_usage_charge()
        end
        #send the email
        email = stub_send_email()
        render json: {email: email}
    end



    private
        def shopify_update_subscription(plan)
            #@shopify_gql_client instantiated in ApplicationController
            UpdateSubsription = @shopify_gql_client.parse <<-'GRAPHQL'
            mutation{
                appSubscriptionCreate(
                    name: plan.name,
                    lineItems: 
                    returnUrl: Rails.configuration.app_root,
                    test:true,
                    trialDays: plan.trial_days
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

            #create the new subscription. Any existing subscription will be auto-cancelled

        end

        def shopify_create_usage_charge
        end

        def shopify_get_current_subscription
        end


        def stub_send_email
            #send email here
            return EmailRecord.create(sent: DateTime.now, subject:"Test email from Shopify", to:"foo@bar.com", shop: @shop)
        end

end
