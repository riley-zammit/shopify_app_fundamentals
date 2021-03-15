class CreateEmailRecords < ActiveRecord::Migration[6.0]
  def change
    create_table :email_records do |t|
      t.datetime :sent
      t.string :subject
      t.string :to
      t.references :shop, null: false, foreign_key: true

      t.timestamps
    end
  end
end
