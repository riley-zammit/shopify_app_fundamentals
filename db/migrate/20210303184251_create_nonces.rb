class CreateNonces < ActiveRecord::Migration[6.0]
  def change
    create_table :nonces do |t|
      t.string :nonce
      t.string :shop_name

      t.timestamps
    end
  end
end
