desc "Populate the 3 plan options"
task :seed_plans do

    unless Plan.exists?(name:"free-plan")
        free = Plan.create(
            display_name:"Free Tier*",
            name:"free-plan",
            cost_monthly:0,
            trial_days:0,
            description:"3 free emails, $1.00 per email after that."
        )
    end

    unless Plan.exists?(name:"silver-tier")
        t1 = Plan.create(
            display_name:"Silver Tier",
            name:"silver-tier",
            cost_monthly:10,
            trial_days:7,
            description:"$10/month for 500 emails, $1.00 per email after that."
        )
    end
    
    unless Plan.exists?(name:"diamond-tier")
        t2 = Plan.create(
            display_name:"Diamond Tier",
            name:"diamond-tier",
            cost_monthly:50,
            trial_days:7,
            description:"$50/month for unlimited emails."
        )
    end
    
end