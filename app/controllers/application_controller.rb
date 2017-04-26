class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception
  before_action :store_current_location, :unless => :devise_controller?
  # before_action :authenticate_user!
  # skip_before_action :authenticate_user!

  include ApplicationHelper

  def store_current_location
    store_location_for(:user, request.url)
  end
  def default_url_options
    { host: ENV["HOST"] || "localhost:3000" }
  end
end
