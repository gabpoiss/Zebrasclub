class AddPackageToOrderItems < ActiveRecord::Migration[5.0]
  def change
    add_column :order_items, :package, :boolean
  end
end
