class AddDefaultPlanToPlan < ActiveRecord::Migration[6.0]
  def change
    add_column :plans, :default_plan, :boolean
  end
end
