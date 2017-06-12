# Be sure to restart your server when you modify this file.

Rails.application.config.session_store :cookie_store, key: '_zebrasclub_session'




# If we want to store more data into a session.

# To make the :active_record_store functionality works in Rails 4/5, you must add the activerecord-session_store gem to your Gemfile:

# gem 'activerecord-session_store'
# then run the migration generator:

# rails generate active_record:session_migration
# And finally set your session store in config/initializers/session_store.rb:

# Rails.application.config.session_store :active_record_store, :key => '_my_app_session'
