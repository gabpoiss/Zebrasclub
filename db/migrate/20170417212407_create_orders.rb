class CreateOrders < ActiveRecord::Migration[5.0]
  def change
    create_table :orders do |t|
      t.references :user, foreign_key: true
      t.string :shipping_address
      t.boolean :paid_status
      t.monetize :amount, currency: { present: false }
      t.json :payment

      t.timestamps
    end
  end
end
