require_relative 'rails_helper'


describe PagesController do

  before :each do
    @items = Item.create(category_id: 1,
    size: "small",
    stock: 25,
    price: 45.05,
    brand: "Bauer",
    description: "Something descriptive is here because im trying to do some test...",
    picture: "500-error-image.jpeg")
  end

  describe "#home" do
    it "list all items" do
      expect(@items).to be_an_instance_of Item
    end
  end

end
