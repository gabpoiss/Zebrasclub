class PagesController < ApplicationController
  skip_before_action :authenticate_user!, only: [ :home, :package ]

  def home
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
      OrderItem.where(user_id: current_user.id).where(package: true)
    else
      # ... unless there is no user
      []
    end

    # Does the user have any previous order_items from a package
    # and have they not requested a brand new package
    if order_items.any? && params[:new_package].nil?

      # NOT USING THE ALGORITHM AND GIVING BACK AN OLD LIST
      # OF ITEMS THE USER HAS PREVIOUSLY MANIPULATED

      # fill @items with all the old items
      order_items.each { |i| @items << Item.find(i.item_id) }

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

      # TODO:
      # otherwise, with no logged in user, the items will be stored
      # in the browser session

    end
  end

  def category_params
    params.require(:category).permit(:item_type)
  end
end
