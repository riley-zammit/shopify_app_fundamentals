class AddPlanToShop < ActiveRecord::Migration[6.0]
  def change
    add_column :shops, :plan, :string
  end
end
