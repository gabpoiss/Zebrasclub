class ItemsController < ApplicationController
  skip_before_action :authenticate_user!, only: [:index]

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
      @min_price = if params[:min_price] == ""
        0
      else
        params[:min_price].to_i * 100
      end
      @max_price = if params[:max_price] == ""
        99999999999999
      else
        params[:max_price].to_i * 100
      end
      @size = params[:size]
      if @size == ""
        @items = Item.where(
          "price > ? AND price < ? AND category_id = ?",
          @min_price, @max_price, @category_id
        )
      else
        @items = Item.where(
          "price > ? AND price < ? AND size = ? AND category_id = ?",
          @min_price, @max_price, @size, @category_id
        )
      end
    else
      @category_id = Category.where(item_type: params[:category])[0].id
      @items = Item.where(category_id: @category_id)
    end
  end

  def package_show
    @item = Item.find(params[:item])
  end
end
