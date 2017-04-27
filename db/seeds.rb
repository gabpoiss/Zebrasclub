puts "Cleaning database..."


Order.destroy_all
OrderItem.destroy_all
Item.destroy_all
Category.destroy_all

puts "Creating categories..."
# # New seed........

categories = ["skate", "helmet", "jersey", "pants", "armband"]

categories.each do  |category|
  Category.create(item_type: category)
end

# Skates

sizes = ["extra small", "small", "medium", "large", "extra large"]

# 1
puts "Creating Items...."

require 'csv'
csv_options = { col_sep: ';', quote_char: '"', headers: :first_row, row_sep: :auto }
filepath    = 'db/items.csv'

CSV.foreach(filepath, csv_options) do |row|
  sizes.each do |size|
    Item.create(category_id: Category.where(item_type: row[4]).first.id,
    size: size,
    stock: rand(10..50),
    price: row[0],
    brand: row[1],
    description: row[2],
    picture: row[3])
  end
end

User.create(first_name: "Martin", last_name: "Giannakopoulos", email: "martingianna@gmail.com", password: "123456")
Order.create(user_id: User.first.id, shipping_address: "123 Fake Street", paid_status: false)





















































# Old seed...........
# Category.create(id: 1, item_type: "skate")
# Category.create(id: 2, item_type: "helmet")
# Category.create(id: 3, item_type: "jersey")
# Category.create(id: 4, item_type: "pants")
# Category.create(id: 5, item_type: "armband")

# size = ["small", "medium", "large", "extra large"]
# price = []
# (1000..100000).step(1000) { |i| price << i }
# brand = ["Itech", "Graph", "CCM", "Bauer"]
# description = "Lorem ipsum dolor sit amet, consectetur adipiscing elit. Maecenas varius orci id tellus ornare, vitae faucibus ipsum ultrices. Fusce tincidunt justo vel consequat tempor. Nam justo nisi, eleifend vitae imperdiet in, tincidunt quis massa. Etiam condimentum finibus diam sed venenatis. Aenean pharetra lacus eu ligula euismod, quis fringilla orci scelerisque. Sed at pellentesque tellus. Sed lacus est, sollicitudin vitae scelerisque id, accumsan nec ligula. In dignissim leo nec lacus facilisis, sed convallis neque placerat. Fusce eros tellus, facilisis vitae semper sit amet, posuere at felis."
# category_id = [1, 2, 3, 4, 5]


# 25.times do
#   cat = category_id.sample
#   sto = stock.sample
#   pri = price.sample
#   bra = brand.sample
#   Item.create(category_id: cat, size: "extra small", stock: sto, price: pri, brand: bra, description: description, picture: "http://res.cloudinary.com/dw8keir6d/image/upload/v1492796418/reebok-hockey-helmet-8k-inset3_y8hycr.jpg")
#   Item.create(category_id: cat, size: "small", stock: sto, price: pri, brand: bra, description: description, picture: "http://res.cloudinary.com/dw8keir6d/image/upload/v1492796418/reebok-hockey-helmet-8k-inset3_y8hycr.jpg")
#   Item.create(category_id: cat, size: "medium", stock: sto, price: pri, brand: bra, description: description, picture: "http://res.cloudinary.com/dw8keir6d/image/upload/v1492796418/reebok-hockey-helmet-8k-inset3_y8hycr.jpg")
#   Item.create(category_id: cat, size: "large", stock: sto, price: pri, brand: bra, description: description, picture: "http://res.cloudinary.com/dw8keir6d/image/upload/v1492796418/reebok-hockey-helmet-8k-inset3_y8hycr.jpg")
#   Item.create(category_id: cat, size: "extra large", stock: sto, price: pri, brand: bra, description: description, picture: "http://res.cloudinary.com/dw8keir6d/image/upload/v1492796418/reebok-hockey-helmet-8k-inset3_y8hycr.jpg")
# end

# User.create(first_name: "Martin", last_name: "Giannakopoulos", email: "martingianna@gmail.com", password: "123456")

# Order.create(user_id: 1, shipping_address: "123 Fake Street", paid_status: false)

# OrderItem.create(order_id: 1, item_id: 2, shipping_status: "not yet ordered", quantity: 1, cart: true)
# OrderItem.create(order_id: 1, item_id: 4, shipping_status: "not yet ordered", quantity: 1, cart: false)
