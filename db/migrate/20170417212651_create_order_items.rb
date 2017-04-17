class CreateOrderItems < ActiveRecord::Migration[5.0]
  def change
    create_table :order_items do |t|
      t.references :order, foreign_key: true
      t.references :item, foreign_key: true
      # t.boolean :completed
      t.integer :quantity
      t.string :shipping_status

      t.timestamps
    end
  end
end
