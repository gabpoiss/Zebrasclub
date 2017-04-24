class PagesController < ApplicationController
  # skip_before_action :authenticate_user!, only: [ :home ]

  def home
    @items = Item.all
    if params[:search]
      if params[:search][:price_lower].present? && params[:search][:price_upper].present?
        @items = @items.where("price > ?", params[:search][:price_lower]).where("price < ?", params[:search][:price_upper])
      end
    end
  end

  def package
    generate_package
  end

  def package_main
    generate_package
    @ready_to_order_package = ready_to_order_package
  end

  def generate_package

    @items = []
    @categories = Category.all

    order_items = if current_user
      User.find(current_user.id).order_items.where(package: true)
    else
      session[:package_items] ? session[:package_items] : []
    end
    #raise
    if order_items.any? && params[:new_package].nil?
      @items = Item.where(id: order_items.map { |order_item| order_item["item_id"] })
    else

      params[:new_package] = nil

      @categories.each do |i|
        if Item.where(category_id: i.id).any?
          @items << Item.where(category_id: i.id).sample
        end
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

  end

  def category_params
    params.require(:category).permit(:item_type)
  end
end
