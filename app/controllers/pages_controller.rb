class PagesController < ApplicationController
  skip_before_action :authenticate_user!, only: [ :home ]

  require 'ostruct'
  module HashToOpenstruct
    def to_ostruct
      o = OpenStruct.new(self)
      each.with_object(o) do |(k,v), o|
        o.send(:"#{k}=", v.to_ostruct) if v.respond_to? :to_ostruct
      end
      o
    end
  end

  Hash.send(:include, HashToOpenstruct)

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
  end

  def generate_package

    # @items will give erb all the items to display on the package
    # items main index page
    @items = []

    # this is probably gonna go away soon
    @categories = Category.all

    order_items = if current_user
      # find the user's order_items from pevious package selection
      User.find(current_user.id).order_items.where(package: true)
    else
      # ... unless there is no user
      session[:package_items] ? session[:package_items] : []
    end

    # Does the user have any previous order_items from a package
    # and have they not requested a brand new package
    if order_items.any? && params[:new_package].nil?

      # NOT USING THE ALGORITHM AND GIVING BACK AN OLD LIST
      # OF ITEMS THE USER HAS PREVIOUSLY MANIPULATED

      # fill @items with all the old items
      if current_user
        order_items.each { |i| @items << Item.find(i.item_id) }
      else
        order_items.each { |i| @items << i.to_ostruct }
      end
    else

      # USING THE ALGORITHM TO MAKE A NEW LIST OF ITEMS TO SHOW
      # ON THE PACKAGE ITEMS MAIN INDEX PAGE

      # this method will no longer give a brand new package
      # untill params[:new_package] is filled again by the
      # new package button (ie., the one on the landing page)
      params[:new_package] = nil

      #### THE ALGORITHM GOES HERE ####

      # at present, it randomly selects items thought the
      # actual algorith will use params to generate item index
      @categories.each do |i|
        if Item.where(category_id: i.id).any?
          @items << Item.where(category_id: i.id).sample
        end
      end

      #### ALGORITHM ENDS HERE ####

      # if there is a user logged on thier items will be stored
      # in the database

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
              category_id: i.category_id,
              item_id: i.id,
              id: i.id,
              price: i.price,
              description: i.description,
              brand: i.brand,
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

  def category_params
    params.require(:category).permit(:item_type)
  end
end
