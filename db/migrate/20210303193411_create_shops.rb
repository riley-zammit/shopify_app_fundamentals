class CreateShops < ActiveRecord::Migration[6.0]
  def change
    create_table :shops do |t|
      t.string :token
      t.string :shop_name

      t.timestamps
    end
  end
end
