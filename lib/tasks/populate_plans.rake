desc "Populate the 3 plan options"
task :seed_plans => :environment do

    unless Plan.exists?(name:"free-plan")
        free = Plan.create(
            display_name:"Free Tier*",
            name:"free-plan",
            cost_monthly:0,
            trial_days:0,
            description:"5 included email, $1.00 per email after that.",
            free_email_limit: 5,
            default_plan:true
        )
    end

    unless Plan.exists?(name:"silver-tier")
        t1 = Plan.create(
            display_name:"Silver Tier",
            name:"silver-tier",
            cost_monthly:10,
            trial_days:7,
            description:"500 included emails, $1.00 per email after that.",
            free_email_limit: 500,
            default_plan: false
        )
    end
    
    unless Plan.exists?(name:"diamond-tier")
        t2 = Plan.create(
            display_name:"Diamond Tier",
            name:"diamond-tier",
            cost_monthly:50,
            trial_days:7,
            description:"Unlimited emails forever.",
            free_email_limit: nil,
            default_plan: false
        )
    end
    
end