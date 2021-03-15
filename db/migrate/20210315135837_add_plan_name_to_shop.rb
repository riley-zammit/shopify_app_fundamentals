class AddPlanNameToShop < ActiveRecord::Migration[6.0]
  def change
    add_column :shops, :plan_name, :string
  end
end
