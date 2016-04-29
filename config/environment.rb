# Load the rails application
require File.expand_path('../application', __FILE__)

# Initialize the rails application
Paint::Application.initialize!


ActionMailer::Base.delivery_method = Rails.env.test? ? :test : :smtp
ActionMailer::Base.smtp_settings = {
  #:tls => true,
  :address => "smtp.gmail.com",
  :port => 587,
  :domain => "angelboy.com",
  :user_name => "info@angelboy.com",
  :password => "OrXOcUQ0G6WV", 
  :authentication => :plain,
  :enable_starttls_auto => true
}
ActionMailer::Base.default_url_options[:host] = Settings.host
ActionMailer::Base.raise_delivery_errors = true
