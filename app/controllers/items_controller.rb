class ItemsController < ApplicationController

  def index
    @categories = Category.all
    @items = Item.all
    @item_list_by_brand = []
    @list_of_categories = []

    Category.all.each do |i|
      if !@list_of_categories.include?(i.item_type)
        @list_of_categories << i.item_type
      end
    end

    if params[:filter]
      list_of_brands = []

      category_id = Category.where(item_type: params[:category])[0].id
      min_price = params[:min_price].to_i * 100
      max_price = params[:max_price].to_i * 100

      item_list = Item.where(
        "price > ? AND price < ? AND category_id = ?",
        min_price, max_price, category_id)

      item_list.each do |i|
        if !list_of_brands.include?(i.brand)
          list_of_brands << i.brand
          @item_list_by_brand << i
        end
      end
    end

  end

  def show
  end

  def package_index
    if params[:filter]
      @category_id = Category.where(item_type: params[:category])[0].id
      min_price = params[:min_max].split(",")[0].to_i * 100
      max_price = params[:min_max].split(",")[1].to_i * 100
      @min_price = params[:min_max].split(",")[0]
      @max_price = params[:min_max].split(",")[1]
      @items = Item.where(
        "price_cents > ? AND price_cents < ? AND category_id = ?",
        min_price, max_price, @category_id
      )
    else
      @min_price = 10
      @max_price = 200
      @category_id = Category.where(item_type: params[:category])[0].id
      @items = Item.where(category_id: @category_id)
    end
    @item = params[:item]

    # yeah, I know this is really dumb, but I'm in a rush
    size_tracker = []
    output = []
    @items.each do |i|
      if !size_tracker.include?([i.brand, i.price, i.category_id])
        size_tracker << [i.brand, i.price, i.category_id]
        output << i
      end
    end
    @items = output

    @item_ids = params[:item_ids]
  end

  def package_show
    @item = Item.find(params[:item])
    @category = @item.category.item_type
    @item_ids = params[:items]
    item_index = @item_ids.find_index(@item.id.to_s)
    @prev = item_index.zero? ? nil : @item_ids[item_index - 1]
    @next = @item_ids[item_index + 1]

    if current_user
      order_item = OrderItem.joins(:order).where(item_id: @item.id, package: true).where("orders.id = ?", current_user.orders.last.id)[0]
      @in_cart = order_item.cart
      @has_size = order_item.size
    else
      session[:package_items].each do |i|
        @in_cart = i["cart"] if i["item_id"] == params[:item].to_i
      end
      session[:package_items].each do |i|
        @has_size = i["size"] if i["item_id"] == params[:item].to_i
      end
    end

    @ready_to_order_package = ready_to_order_package
  end
end
