require_relative 'boot'

require 'rails/all'

# Require the gems listed in Gemfile, including any gems
# you've limited to :test, :development, or :production.
Bundler.require(*Rails.groups)

module ShopifyAppFoundation
  class Application < Rails::Application
    # Initialize configuration defaults for originally generated Rails version.
    config.load_defaults 6.0

    #-----CONFIG SHOPIFY APP------
    config.api_key = ENV['SHOPIFY_API_KEY']
    config.api_secret = ENV['SHOPIFY_API_SECRET']

    config.app_root = "https://rjz.ngrok.io"
    config.scope = "write_customers" #grants read/write
  end
end
