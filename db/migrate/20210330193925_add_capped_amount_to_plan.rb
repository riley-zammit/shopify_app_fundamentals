class AddCappedAmountToPlan < ActiveRecord::Migration[6.0]
  def change
    add_column :plans, :capped_amount, :integer
  end
end
