class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception
  before_action :set_locale

  include ApplicationHelper

  def store_current_location
    store_location_for(:user, request.url)
  end

  # Setup metatags to overwrite the default absolute_url
  # AND
  # Setup the right the I18n locale
  def default_url_options
    { host: ENV["HOST"] || "localhost:3000" }
    { locale: I18n.locale == I18n.default_locale ? nil : I18n.locale }
  end

  def set_locale
    I18n.locale = params[:locale] || I18n.default_locale
  end

end
