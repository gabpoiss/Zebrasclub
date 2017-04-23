class OrderitemsController < ApplicationController

  def index
    @order_items = if current_user
       User.find(current_user.id).order_items.where(cart: true)
    else
      session[:package_items].select { |i| i["cart"] }
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
          if i["item_id"] == params[:id].to_i
            i["quantity"] = params[:quantity]
          end
        end
      end
      redirect_to orderitems_path
    elsif params[:size_update]
      @default_item = Item.find(params[:id])
      @category = @default_item.category.item_type
      @item = Item.where(size: params[:size], brand: @default_item.brand, category: @default_item.category, price: @default_item.price)[0]
      @has_size = true
      @in_cart = false
      if current_user
        order_item = OrderItem.joins(:order).where(item_id: params[:id], package: true).where("orders.user_id = ?", current_user.id)[0]
        order_item.update(item_id: @item.id, size: true)
        order_item.save
      else
        session[:package_items].each do |i|
          if i["item_id"] == @default_item.id && i["package"] == true
            i["item_id"] = @item.id
            i["size"] = true
          end
        end
      end
      render "items/package_show"
    elsif params[:remove_from_package]
      @criteria_for_extermination = Item.find(params[:id]).category.item_type
      if current_user
        order_item = OrderItem.joins(:order).where(item_id: params[:id], package: true).where("orders.user_id = ?", current_user.id)[0]
        order_item.update(package: false)
        order_item.save
      else
        session[:package_items].delete_if { |i| i["item_id"] == params[:id].to_i }
      end
      @items = []
      @categories = Category.all

      order_items = if current_user
        User.find(current_user.id).order_items.where(package: true)
      else
        session[:package_items] ? session[:package_items] : []
      end

      @items = Item.where(id: order_items.map { |order_item| order_item["item_id"] })

      @ready_to_order_package = false

      if current_user
        order_items = current_user.order_items.where(package: true)
        @ready_to_order_package = order_items.all? { |i| i.cart }
      else
        @ready_to_order_package = session[:package_items].all? { |i| i["cart"]}
      end

      render "pages/package_main"
    else
      if current_user
        order_item = OrderItem.joins(:order).where(item_id: params[:id], package: true).where("orders.user_id = ?", current_user.id)
        order_item[0].cart = true
        order_item[0].save
      else
        session[:package_items].each do |i|
          if i["item_id"] == params[:id].to_i
            i["cart"] = true
          end
        end
      end
      @has_size = true
      @in_cart = true
      @item = Item.find(params[:id])
      @category = @item.category.item_type

      @ready_to_order_package = false

      if current_user
        order_items = current_user.order_items.where(package: true)
        @ready_to_order_package = order_items.all? { |i| i.cart }
      else
        @ready_to_order_package = session[:package_items].all? { |i| i["cart"]}
      end
      render "items/package_show"
    end
  end

  def destroy
    if current_user
      order_item = OrderItem.find(params[:id])
      order_item.cart = false
      order_item.size = false
      order_item.quantity = 1
      order_item.save
    else
      session[:package_items].each do |i|
        if i["item_id"] == params[:id].to_i
          i["cart"] = false
          i["size"] = false
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
      @category = Item.find(new_item_id).category.item_type
      render "items/package_show"
    else
      new_item = Item.find(new_item_id)
      session[:package_items].delete_if do |i|
        i["item_id"] == old_item_id.to_i
      end
      session[:package_items] << {
        item_id: new_item.id,
        quantity: 1,
        shipping_status: "not yet ordered",
        package: true,
        size: true,
        cart: false
      }
      @item = new_item
      @category = new_item.category.item_type
      render "items/package_show"
    end
  end
end
