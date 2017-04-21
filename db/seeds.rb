Category.create(id: 1, item_type: "skate")
Category.create(id: 2, item_type: "helmet")
Category.create(id: 3, item_type: "jersey")
Category.create(id: 4, item_type: "pants")
Category.create(id: 5, item_type: "armband")

size = ["small", "medium", "large", "extra large"]
stock = (1..10).to_a
price = []
(1000..100000).step(1000) { |i| price << i }
brand = ["Itech", "Graph", "CCM", "Bauer"]
description = "Lorem ipsum dolor sit amet, consectetur adipiscing elit. Maecenas varius orci id tellus ornare, vitae faucibus ipsum ultrices. Fusce tincidunt justo vel consequat tempor. Nam justo nisi, eleifend vitae imperdiet in, tincidunt quis massa. Etiam condimentum finibus diam sed venenatis. Aenean pharetra lacus eu ligula euismod, quis fringilla orci scelerisque. Sed at pellentesque tellus. Sed lacus est, sollicitudin vitae scelerisque id, accumsan nec ligula. In dignissim leo nec lacus facilisis, sed convallis neque placerat. Fusce eros tellus, facilisis vitae semper sit amet, posuere at felis."
category_id = [1, 2, 3, 4, 5]

25.times do
  cat = category_id.sample
  sto = stock.sample
  pri = price.sample
  bra = brand.sample
  Item.create(category_id: cat, size: "extra small", stock: sto, price: pri, brand: bra, description: description)
  Item.create(category_id: cat, size: "small", stock: sto, price: pri, brand: bra, description: description)
  Item.create(category_id: cat, size: "medium", stock: sto, price: pri, brand: bra, description: description)
  Item.create(category_id: cat, size: "large", stock: sto, price: pri, brand: bra, description: description)
  Item.create(category_id: cat, size: "extra large", stock: sto, price: pri, brand: bra, description: description)
end

User.create(first_name: "Martin", last_name: "Giannakopoulos", email: "martingianna@gmail.com", password: "123456")

Order.create(user_id: 1, shipping_address: "123 Fake Street", paid_status: false)

OrderItem.create(order_id: 1, item_id: 2, shipping_status: "not yet ordered", quantity: 1, cart: true)
OrderItem.create(order_id: 1, item_id: 4, shipping_status: "not yet ordered", quantity: 1, cart: false)
