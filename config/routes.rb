Rails.application.routes.draw do
  devise_for :users
  root to: 'pages#home'

  # grid with package items
  get "/package", to: "pages#package", as: "package"

  # returns .js to choose item of a certain category
  post "/package/category", to: "items#package_index", as: "package_items"

  # returns .js to view item/brand details and change size
  post "/package/item", to: "items#package_show", as: "package_item"

  # list of individual items
  get "/items", to: "items#index", as: "items"

  # individual itembrand details (not inside package view)
  get "/items/:id", to: "items#show", as: "item"

  # list of past orders
  get "/order/index", to: "orders#index", as: "orders"

  # view shopping cart
  get "/orderitem", to: "orderitems#index", as: "orderitems"

  # adding an item to your cart
  post "/orderitem", to: "orderitems#create", as: "orderitem"

  # editting and removing items from your cart
  patch "/orderitem/:id", to: "orderitems#update", as: "orderitem"
  delete "/orderitem/:id", to: "orderitems#destroy", as: "orderitem"
end
