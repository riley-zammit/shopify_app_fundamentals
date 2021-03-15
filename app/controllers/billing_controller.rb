class BillingController < AuthenticatedController
    
    def show
        render json:{plans: Plan.all}
    end
    
    def update
        plan = params[:plan]
        debug=0
        render json: {status: 'ok', plan:plan}
    end

    def charge_for_sent_email
    end



end
