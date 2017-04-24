class OrderItem < ApplicationRecord
  belongs_to :order, optional: true
  belongs_to :item

  after_update :update_order

  def update_order
    self.order.compute_price
  end

  def user
    self.order.user
  end
end
