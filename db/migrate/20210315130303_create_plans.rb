class CreatePlans < ActiveRecord::Migration[6.0]
  def change
    create_table :plans do |t|
      t.string :name
      t.integer :cost_monthly
      t.integer :trial_days

      t.timestamps
    end
  end
end
