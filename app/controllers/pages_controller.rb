class PagesController < ApplicationController
  # skip_before_action :authenticate_user!, only: [ :home ]

  def home
    store_current_location
    @items = Item.all
    if params[:search]
      if params[:search][:price_lower].present? && params[:search][:price_upper].present?
        @items = @items.where("price > ?", params[:search][:price_lower]).where("price < ?", params[:search][:price_upper])
      end
    end

    @users_email = User.create
  end
  #   def initialize(user)
  #   @user = user
  #   @gibbon = Gibbon::Request.new(api_key: ENV['MAILCHIMP_API_KEY'])
  #   @list_id = ENV['MAILCHIMP_LIST_ID']
  # end

  # def call
  #   @gibbon.lists(@list_id).members.create(
  #     body: {
  #       email_address: @user.email,
  #       status: "subscribed",
  #       # merge_fields: {
  #       #   FNAME: @user.first_name,
  #       #   LNAME: @user.last_name
  #       # }
  #     }
  #   )
  # end

  def package
    store_current_location
    generate_package
    @ready_to_order_package = ready_to_order_package
    redirect_to "/package" if params[:search]
  end

  def package_main
    generate_package
    @ready_to_order_package = ready_to_order_package
  end

  def generate_package

    @items = []
    @categories = Category.all

    order_items = if current_user
      User.find(current_user.id).order_items.where(package: true, order_id: current_user.orders.last)
    else
      session[:package_items] ? session[:package_items] : []
    end

    if params[:search].nil?
      if order_items.any?
        @items = Item.where(id: order_items.map { |order_item| order_item["item_id"] })
      else
        redirect_to "/"
      end
    else

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

      @categories.each do |i|

        max_item_price = ITEM_PRICE_WEIGTHS[i.item_type.to_sym] * params[:search][:price_upper].to_i
        selected_item = Item.where("category_id = ? AND price_cents < ?", i.id, max_item_price * 100).order("price_cents DESC").first
        if selected_item.nil?
          selected_item = Item.where(category_id: i.id).order("price_cents ASC").first
        end
        @items << selected_item

      end

      if current_user
        unless User.find(current_user.id).orders.any?
          Order.create(user_id: current_user.id, paid_status: false)
        end
        @items.each do |i|
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
        @items.each do |i|
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

  def done
    @shipping_address = params[:shipping_address]
    @orderitems = OrderItem.where(cart: true, order_id: current_user.orders.last.id)
    @order = current_user.orders.last
    Order.create(user_id: current_user.id)
  end

  def category_params
    params.require(:category).permit(:item_type)
  end
end
