class PagesController < ApplicationController
  skip_before_action :authenticate_user!, only: [ :home, :package ]

  def home
    # @min_price = []
    # @max_price = []
    # @items = Item.all

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
    @categories.each do |i|
      if Item.where(category_id: i.id).any?
        @items << Item.where(category_id: i.id).sample
      end
    end
  end

  def package_main
    @categories = Category.all
    @items = Item.all
  end

  def category_params
    params.require(:category).permit(:item_type)
  end
end
