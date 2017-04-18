class PagesController < ApplicationController
  skip_before_action :authenticate_user!, only: [ :home, :package ]

  def home
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
