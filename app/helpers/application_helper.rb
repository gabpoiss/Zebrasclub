module ApplicationHelper

  def all_items_in_package
    order_items = if current_user
      User.find(current_user.id).order_items.where(package: true, order_id: current_user.orders.last)
    else
      session[:package_items] ? session[:package_items] : []
    end

    Item.where(id: order_items.map { |order_item| order_item["item_id"] })
  end

  def ready_to_order_package
    if current_user
      order_items = current_user.order_items.where(package: true, order_id: current_user.orders.last)
      order_items.all? { |i| i.cart } ? true : false
    else
      session[:package_items].all? { |i| i["cart"]} ? true : false
    end
  end

  ITEM_PRICE_WEIGTHS = {
    skate: 0.33,
    helmet: 0.23,
    jersey: 0.23,
    armband: 0.01,
    pants: 0.2
  }

end
