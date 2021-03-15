class AddDisplayNameToPlan < ActiveRecord::Migration[6.0]
  def change
    add_column :plans, :display_name, :string
  end
end
