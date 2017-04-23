module ApplicationHelper

  def all_items_in_package
    order_items = if current_user
      User.find(current_user.id).order_items.where(package: true)
    else
      session[:package_items] ? session[:package_items] : []
    end

    Item.where(id: order_items.map { |order_item| order_item["item_id"] })
  end

  def ready_to_order_package
    if current_user
      order_items = current_user.order_items.where(package: true)
      order_items.all? { |i| i.cart }
    else
      session[:package_items].all? { |i| i["cart"]}
    end
  end

end
