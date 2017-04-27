class OrderitemsController < ApplicationController

  def index
    store_current_location
    if current_user
      @order = Order.where(user_id: current_user.id).last
      @order.compute_price
    end
      @logged_out_order_price = 0
      session[:package_items].each do |i|
        if i["cart"]
          @logged_out_order_price += Item.find(i["item_id"]).price * i["quantity"].to_i
        end
      end
    else
    @order_items = if current_user
       User.find(current_user.id).order_items.where(cart: true)
    else
      session[:package_items].select { |i| i["cart"] }
    end
  end

  def update
    if params[:quantity_update]
      quantity_update
    elsif params[:size_update]
      size_update
    elsif params[:remove_from_package]
      remove_from_package
    else
      add_to_cart
    end
  end

  def quantity_update
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
  end

  def size_update
    @default_item = Item.find(params[:id])
    @category = @default_item.category.item_type
    @item = Item.where(size: params[:size], brand: @default_item.brand, category_id: @default_item.category_id)[0]
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
    @item_ids = params[:items]
    item_index = @item_ids.find_index(@default_item.id.to_s)
    @item_ids[item_index] = @item.id.to_s
    @prev = item_index.zero? ? nil : @item_ids[item_index - 1]
    @next = @item_ids[item_index + 1]

    render "items/package_show"
  end

  def remove_from_package
    @criteria_for_elimination = Item.find(params[:id]).category.item_type
    if current_user
      order_item = OrderItem.joins(:order).where(item_id: params[:id], package: true).where("orders.user_id = ?", current_user.id)[0]
      order_item.update(package: false)
      order_item.save
    else
      session[:package_items].delete_if { |i| i["item_id"] == params[:id].to_i }
    end
    # binding.pry
    @categories = Category.all

    @items = all_items_in_package

    @ready_to_order_package = ready_to_order_package

    render "pages/package_main"
  end

  def add_to_cart
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

    @items = all_items_in_package

    @ready_to_order_package = ready_to_order_package

    render "pages/package_main"
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

    end

    @item_ids = params[:item_ids]
    item_index = @item_ids.find_index(old_item_id.to_s)
    @item_ids[item_index] = new_item_id.to_s
    @prev = item_index.zero? ? nil : @item_ids[item_index - 1]
    @next = @item_ids[item_index + 1]

    render "items/package_show"
  end

  def show
    @order = Order.where(paid_status: 'paid').find(params[:id])
  end
end
