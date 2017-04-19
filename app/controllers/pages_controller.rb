class PagesController < ApplicationController
  skip_before_action :authenticate_user!, only: [ :home, :package ]

  def home
    @items = Item.all
    if params[:search]
      if params[:search][:price_lower].present? && params[:search][:price_upper].present?
        @items = @items.where("price > ?", params[:search][:price_lower]).where("price < ?", params[:search][:price_upper])
      end
    end
  end

  def package
    @items = []
    @categories = Category.all
    if current_user
      order_items = OrderItem.where(user_id: current_user.id).where(package: true)
    else
      order_items = []
    end
    if order_items.any? && params[:new_package].nil?
      order_items.each do |i|
        @items << Item.find(i.item_id)
      end
    else
      # randomly selects items in place of an actual algorithm
      # actual algorith will use params to generate item index
      params[:new_package] = nil
      @categories.each do |i|
        if Item.where(category_id: i.id).any?
          @items << Item.where(category_id: i.id).sample
        end
      end
      if current_user
        @items.each do |i|
          OrderItem.create(
            user_id: current_user.id,
            item_id: i.id,
            quantity: 1,
            shipping_status: "not yet ordered",
            package: true,
            size: false
          )
        end
      end
    end
  end

  # identical to method 'package' but returns .js from post requests
  def package_main
    @items = []
    @categories = Category.all
    if current_user
      order_items = OrderItem.where(user_id: current_user.id).where(package: true)
    else
      order_items = []
    end
    if order_items.any? && params[:new_package].nil?
      order_items.each do |i|
        @items << Item.find(i.item_id)
      end
    else
      # randomly selects items in place of an actual algorithm
      # actual algorith will use params to generate item index
      params[:new_package] = nil
      @categories.each do |i|
        if Item.where(category_id: i.id).any?
          @items << Item.where(category_id: i.id).sample
        end
      end
      if current_user
        @items.each do |i|
          OrderItem.create(
            user_id: current_user.id,
            item_id: i.id,
            quantity: 1,
            shipping_status: "not yet ordered",
            package: true,
            size: false
          )
        end
      end
    end
  end

  def category_params
    params.require(:category).permit(:item_type)
  end
end
