class AddCartToOrderItems < ActiveRecord::Migration[5.0]
  def change
    add_column :order_items, :cart, :boolean
  end
end
