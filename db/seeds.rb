Category.create(item_type: "skate")
Category.create(item_type: "helmet")

Item.create(category_id: 2, size: "large", stock: 2, price: 20000, brand: "CCM", description: "A helmet we recommend for beginners", picture: "../app/assets/images/ccm-hockey-helmet-resistance-inset3.jpg")
Item.create(category_id: 2, size: "small", stock: 1, price: 15000, brand: "CCM", description: "A helmet we recommend for beginners", picture: "../../assets/images/ccm-hockey-helmet-resistance-inset4.jpg")
Item.create(category_id: 2, size: "large", stock: 1, price: 25000, brand: "Bauer", description: "A helmet we recommend for experts", picture: "../../assets/images/ccm-hockey-helmet-resistance-inset5.jpg")

Item.create(category_id: 1, size: "9", stock: 1, price: 40000, brand: "Itech", description: "Skates we recommend for experts", picture: "../../assets/images/ccm-hockey-helmet-resistance-inset5.jpg")
Item.create(category_id: 1, size: "10", stock: 2, price: 40000, brand: "Graph", description: "Skates we recommend for experts", picture: "../../assets/images/ccm-hockey-helmet-resistance-inset5.jpg")

User.create(first_name: "Martin", last_name: "Giannakopoulos", email: "martingianna@gmail.com", password: "123456")

Order.create(user_id: 1, shipping_address: "123 Fake Street", paid_status: false)

OrderItem.create(order_id: 1, item_id: 2, shipping_status: "not yet ordered", quantity: 1)
OrderItem.create(order_id: 1, item_id: 4, shipping_status: "not yet ordered", quantity: 1)
