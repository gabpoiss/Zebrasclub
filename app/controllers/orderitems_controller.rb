class OrderitemsController < ApplicationController
  skip_before_action :authenticate_user!

  def index
    if current_user
      @order_items = OrderItem.joins(:order).where(cart: true).where("orders.user_id = ?", current_user.id)
    else
    end
  end

  def create
  end

  def update
    if params[:quantity_update]
      if current_user
        order_item = OrderItem.find(params[:id])
        order_item.quantity = params[:quantity]
        order_item.save
        @order_items = OrderItem.joins(:order).where(cart: true).where("orders.user_id = ?", current_user.id)
      else
        session[:package_items].each do |i|
          if i["id"] == params[:item_id].to_i
            i["quantity"] = params[:quantity]
          end
        end
      end
      redirect_to orderitems_path
    elsif params[:size_update]
      order_item = OrderItem.find(params[:id])
      item = order_item.item
      new_item = Item.where(price: item.price, brand: item.brand, category_id: item.category_id, size: params[:size])[0]
      order_item.item = new_item
      order_item.size = true
      order_item.save
      @item = new_item
      @category = @item.category_id
      render "items/package_show"
    else
      if current_user
        order_item = OrderItem.joins(:order).where(item_id: params[:id], package: true).where("orders.user_id = ?", current_user.id)
        order_item[0].cart = true
        order_item[0].save
      else
        session[:package_items].each do |i|
          if i["id"] == params[:id].to_i
            i["cart"] = true
          end
        end
      end
      @item = Item.find(params[:id])
      @category = @item.category_id
      render "items/package_show"
    end
  end

  def destroy
    if current_user
      order_item = OrderItem.find(params[:id])
      order_item.cart = false
      order_item.quantity = 1
      order_item.save
    else
      session[:package_items].each do |i|
        if i["id"] == params[:id].to_i
          i["cart"] = false
          i["quantity"] = 1
        end
      end
    end
    redirect_to orderitems_path
  end

  def package_replace
    old_item_id = params[:old_item_id]
    new_item_id = params[:new_item_id]
    if current_user
      order_item = OrderItem.joins(:order).where(item_id: old_item_id, package: true).where("orders.user_id = ?", current_user.id)[0]
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
