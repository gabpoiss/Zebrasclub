class ItemsController < ApplicationController

  def index

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
  end

  def package_show
  end
end
