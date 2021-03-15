class AddFreeEmailLimitToPlan < ActiveRecord::Migration[6.0]
  def change
    add_column :plans, :free_email_limit, :integer
  end
end
