Rails.application.routes.draw do
  devise_for :users
  root to: 'pages#home'

  # grid with package items
  get "/package", to: "pages#package", as: "package"

  # returns .js to choose item of a certain category
  post "/package/index", to: "items#package_index", as: "package_items"

  # returns .js to view item/brand details and change size
  post "/package/show", to: "items#package_show", as: "package_item"

  # list of individual items
  get "/items", to: "items#index", as: "items"

  # individual item/brand details (not inside package view)
  get "/items/:id", to: "items#show", as: "item"

  # list of past orders
  get "/orders", to: "orders#index", as: "orders"

  # view shopping cart
  get "/orderitems", to: "orderitems#index", as: "orderitems"

  # adding an item to your cart
  post "/orderitems", to: "orderitems#create", as: "new_orderitem"

  # editting and removing items from your cart
  patch "/orderitems/:id", to: "orderitems#update", as: "edit_orderitem"
  delete "/orderitems/:id", to: "orderitems#destroy", as: "destroy_orderitem"
end
