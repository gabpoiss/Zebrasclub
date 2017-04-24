class Order < ApplicationRecord
  belongs_to :user
  has_many :order_items
  monetize :amount_cents

  def compute_price
    order_items.each do |order_item|
      self.amount_cents += order_item.item.price_cents * order_item.quantity
    end
    self.save
  end
end
