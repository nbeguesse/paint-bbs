class ApplicationController < ActionController::Base
  protect_from_forgery
  helper :all 
  include Authentication
  before_filter :set_request
  # include ::SslRequirement

  helper_method :secure?
  def secure?
    Rails.env.production?
  end

  def set_request
    @request = request
  end
end
