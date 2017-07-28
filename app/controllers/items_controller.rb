class ItemsController < ApplicationController

  def index
    store_current_location
    # generate_individual_items
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
        "price_cents > ? AND price_cents < ? AND category_id = ?",
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
      # if @list_of_categories = "helmet"
        @item = Item.find(params[:id])

      # end
  end

  def package_index
    @category_id = Category.where(item_type: params[:category])[0].id
    @filter_max = ((Item.where(category_id: @category_id).order(price_cents: :desc)[0].price_cents / 100) + 10).round(-1)
    if params[:filter]
      min_price = params[:min_max].split(",")[0].to_i * 100
      max_price = params[:min_max].split(",")[1].to_i * 100
      @min_price = params[:min_max].split(",")[0]
      @max_price = params[:min_max].split(",")[1]
      @items = Item.where(
        "price_cents > ? AND price_cents < ? AND category_id = ?",
        min_price, max_price, @category_id
        ).order(price_cents: "DESC")
    else
      @min_price = 10
      @max_price = 1000
      @items = Item.where(category_id: @category_id).order(price_cents: "DESC")
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

  # def generate_individual_items

  #   @individual_items = []
  #   @categories = Category.all

  #   order_items = if current_user
  #     User.find(current_user.id).order_items.where(package: true, order_id: current_user.orders.last)
  #   else
  #     session[:package_items] ? session[:package_items] : []
  #   end

  #     # MAKE SURE TO WIPE ANY ORDERITEMS IF THEY HAVE ANY
  #     if order_items.any?
  #       if current_user
  #         current_user.orders.last.order_items.destroy_all
  #         current_user.orders.last.update(amount_cents: 0)
  #         current_user.orders.last.save
  #       else
  #         session[:package_items] = []
  #       end
  #     end
  #     @categories.each do |i|

  #       # max_item_price = ITEM_PRICE_WEIGTHS[i.item_type.to_sym] * params[:search][:price_upper].to_i
  #       selected_item = Item.where("category_id = ? AND price_cents = price_cents", i.id ).order("price_cents DESC").first
  #       if selected_item.nil?
  #         selected_item = Item.where(category_id: i.id).order("price_cents ASC").first
  #       end
  #       @individual_items << selected_item

  #     end

  #     if current_user
  #       unless User.find(current_user.id).orders.any?
  #         Order.create(user_id: current_user.id, paid_status: false)
  #       end
  #       @individual_items.each do |i|
  #         OrderItem.create(
  #           order_id: current_user.orders.last.id,
  #           item_id: i.id,
  #           quantity: 1,
  #           shipping_status: "not yet ordered",
  #           package: true,
  #           size: false,
  #           cart: false
  #         )
  #       end
  #     else
  #       session[:package_items] = []
  #       @individual_items.each do |i|
  #           session[:package_items] << {
  #             item_id: i.id,
  #             quantity: 1,
  #             shipping_status: "not yet ordered",
  #             package: true,
  #             size: false,
  #             cart: false
  #           }
  #       end
  #     end
  #   # end
  # end

  def helmets
    smalldefault = "small"
    @helmets = []
    @helmets = Item.where("category_id = 2 AND price_cents = price_cents AND size = ? ", smalldefault)

    order_items = if current_user
      User.find(current_user.id).order_items.where(package: true, order_id: current_user.orders.last)
    else
      session[:package_items] ? session[:package_items] : []
    end

      # MAKE SURE TO WIPE ANY ORDERITEMS IF THEY HAVE ANY
      if order_items.any?
        if current_user
          current_user.orders.last.order_items.destroy_all
          current_user.orders.last.update(amount_cents: 0)
          current_user.orders.last.save
        else
          session[:package_items] = []
        end
      end
      if current_user
        unless User.find(current_user.id).orders.any?
          Order.create(user_id: current_user.id, paid_status: false)
        end
        @helmets.each do |i|
          OrderItem.create(
            order_id: current_user.orders.last.id,
            item_id: i.id,
            quantity: 1,
            shipping_status: "not yet ordered",
            package: true,
            size: false,
            cart: false
          )
        end
      else
        session[:package_items] = []
        @helmets.each do |i|
            session[:package_items] << {
              item_id: i.id,
              quantity: 1,
              shipping_status: "not yet ordered",
              package: true,
              size: false,
              cart: false
            }
        end
      end
        render json: {status: 'SUCCESS', message: 'Loaded successfully', data: @helmets}, status: :ok


  end

  def skates
    smalldefault = "small"
    @skates = []
    @skates = Item.where("category_id = 1 AND price_cents = price_cents AND size = ? ", smalldefault)

    order_items = if current_user
      User.find(current_user.id).order_items.where(package: true, order_id: current_user.orders.last)
    else
      session[:package_items] ? session[:package_items] : []
    end

      # MAKE SURE TO WIPE ANY ORDERITEMS IF THEY HAVE ANY
      if order_items.any?
        if current_user
          current_user.orders.last.order_items.destroy_all
          current_user.orders.last.update(amount_cents: 0)
          current_user.orders.last.save
        else
          session[:package_items] = []
        end
      end
      if current_user
        unless User.find(current_user.id).orders.any?
          Order.create(user_id: current_user.id, paid_status: false)
        end
        @skates.each do |i|
          OrderItem.create(
            order_id: current_user.orders.last.id,
            item_id: i.id,
            quantity: 1,
            shipping_status: "not yet ordered",
            package: true,
            size: false,
            cart: false
          )
        end
      else
        session[:package_items] = []
        @skates.each do |i|
            session[:package_items] << {
              item_id: i.id,
              quantity: 1,
              shipping_status: "not yet ordered",
              package: true,
              size: false,
              cart: false
            }
        end
      end
  end

  def jerseys
    smalldefault = "small"
    @jerseys = []
    @jerseys = Item.where("category_id = 3 AND price_cents = price_cents AND size = ? ", smalldefault)

    order_items = if current_user
      User.find(current_user.id).order_items.where(package: true, order_id: current_user.orders.last)
    else
      session[:package_items] ? session[:package_items] : []
    end

      # MAKE SURE TO WIPE ANY ORDERITEMS IF THEY HAVE ANY
      if order_items.any?
        if current_user
          current_user.orders.last.order_items.destroy_all
          current_user.orders.last.update(amount_cents: 0)
          current_user.orders.last.save
        else
          session[:package_items] = []
        end
      end
      if current_user
        unless User.find(current_user.id).orders.any?
          Order.create(user_id: current_user.id, paid_status: false)
        end
        @jerseys.each do |i|
          OrderItem.create(
            order_id: current_user.orders.last.id,
            item_id: i.id,
            quantity: 1,
            shipping_status: "not yet ordered",
            package: true,
            size: false,
            cart: false
          )
        end
      else
        session[:package_items] = []
        @jerseys.each do |i|
            session[:package_items] << {
              item_id: i.id,
              quantity: 1,
              shipping_status: "not yet ordered",
              package: true,
              size: false,
              cart: false
            }
        end
      end
  end

  def armbands
    smalldefault = "small"
    @armbands = []
    @armbands = Item.where("category_id = 5 AND price_cents = price_cents AND size = ? ", smalldefault)

    order_items = if current_user
      User.find(current_user.id).order_items.where(package: true, order_id: current_user.orders.last)
    else
      session[:package_items] ? session[:package_items] : []
    end

      # MAKE SURE TO WIPE ANY ORDERITEMS IF THEY HAVE ANY
      if order_items.any?
        if current_user
          current_user.orders.last.order_items.destroy_all
          current_user.orders.last.update(amount_cents: 0)
          current_user.orders.last.save
        else
          session[:package_items] = []
        end
      end
      if current_user
        unless User.find(current_user.id).orders.any?
          Order.create(user_id: current_user.id, paid_status: false)
        end
        @armbands.each do |i|
          OrderItem.create(
            order_id: current_user.orders.last.id,
            item_id: i.id,
            quantity: 1,
            shipping_status: "not yet ordered",
            package: true,
            size: false,
            cart: false
          )
        end
      else
        session[:package_items] = []
        @armbands.each do |i|
            session[:package_items] << {
              item_id: i.id,
              quantity: 1,
              shipping_status: "not yet ordered",
              package: true,
              size: false,
              cart: false
            }
        end
      end
  end

  def pants
    smalldefault = "small"
    @pants = []
    @pants = Item.where("category_id = 4 AND price_cents = price_cents AND size = ? ", smalldefault)

    order_items = if current_user
      User.find(current_user.id).order_items.where(package: true, order_id: current_user.orders.last)
    else
      session[:package_items] ? session[:package_items] : []
    end

      # MAKE SURE TO WIPE ANY ORDERITEMS IF THEY HAVE ANY
      if order_items.any?
        if current_user
          current_user.orders.last.order_items.destroy_all
          current_user.orders.last.update(amount_cents: 0)
          current_user.orders.last.save
        else
          session[:package_items] = []
        end
      end
      if current_user
        unless User.find(current_user.id).orders.any?
          Order.create(user_id: current_user.id, paid_status: false)
        end
        @pants.each do |i|
          OrderItem.create(
            order_id: current_user.orders.last.id,
            item_id: i.id,
            quantity: 1,
            shipping_status: "not yet ordered",
            package: true,
            size: false,
            cart: false
          )
        end
      else
        session[:package_items] = []
        @pants.each do |i|
            session[:package_items] << {
              item_id: i.id,
              quantity: 1,
              shipping_status: "not yet ordered",
              package: true,
              size: false,
              cart: false
            }
        end
      end
  end
end
