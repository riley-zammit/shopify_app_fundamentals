class AddShopifySubscriptionIdToShop < ActiveRecord::Migration[6.0]
  def change
    add_column :shops, :shopify_subs_id, :string
  end
end
