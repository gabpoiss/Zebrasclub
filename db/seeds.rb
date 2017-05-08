puts "Cleaning database..."


OrderItem.destroy_all
Order.destroy_all
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
    puts "Equipment Type: #{row[4].upcase} - ItemsBrand: #{row[1]}"
end

User.create(first_name: "Martin", last_name: "Giannakopoulos", email: "martingianna@gmail.com", password: "123456")
Order.create(user_id: User.first.id, shipping_address: "123 Fake Street", paid_status: false)

