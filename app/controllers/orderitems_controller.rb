class OrderitemsController < ApplicationController
  skip_before_action :authenticate_user!

  def index
  end

  def create
  end

  def update
  end

  def destroy
  end

  def package_replace
    old_item_id = params[:old_item_id]
    new_item_id = params[:new_item_id]
    if current_user
      order_item = OrderItem.where(item_id: old_item_id).where(package: true)[0]
      order_item.item_id = new_item_id
      order_item.save
      @item = Item.find(new_item_id)
      @category = Item.find(new_item_id).category_id
      render "items/package_show"
    else
      new_item = Item.find(new_item_id)
      # binding.pry
      session[:package_items].delete_if do |i|
        i["id"] == old_item_id.to_i
      end
      session[:package_items] << {
        category_id: new_item.category_id,
        item_id: new_item.id,
        id: new_item.id,
        price: new_item.price,
        description: new_item.description,
        brand: new_item.brand,
        quantity: 1,
        shipping_status: "not yet ordered",
        package: true,
        size: true,
        cart: false
      }
      @item = new_item
      @category = new_item.category_id
      render "items/package_show"
    end
  end
end
