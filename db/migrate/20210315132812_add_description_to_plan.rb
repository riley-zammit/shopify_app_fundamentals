class AddDescriptionToPlan < ActiveRecord::Migration[6.0]
  def change
    add_column :plans, :description, :text
  end
end
