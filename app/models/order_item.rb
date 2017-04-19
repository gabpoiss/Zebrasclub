class OrderItem < ApplicationRecord
  belongs_to :order, optional: true
  belongs_to :item

  def user
    self.order.user
  end
end
