Rails.application.routes.draw do
  devise_for :users
  root to: 'pages#home'

  # grid with package items
  get "/package", to: "pages#package"

  # returns .js to choose item of a certain category
  post "/package/category", to: "items#category_index"

  # returns .js to view item/brand details and change size
  post "/package/item", to: "items#package_show"

  # list of individual items
  get "/items", to: "items#index"

  # individual itembrand details (not inside package view)
  get "/items/:id", to: "items#show"

  # list of past orders
  get "/order/index", to: "orders#index"

  # view shopping cart
  get "/orderitem", to: "orderitems#index"

  # adding an item to your cart
  post "/orderitem", to: "orderitems#create"

  # editting and removing items from your cart
  patch "/orderitem/:id", to: "orderitems#update"
  delete "/orderitem/:id", to: "orderitems#destroy"
end
