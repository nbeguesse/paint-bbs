# This file is copied to spec/ when you run 'rails generate rspec:install'
require 'simplecov'
require 'simplecov-rcov'
SimpleCov.formatter = SimpleCov::Formatter::RcovFormatter
SimpleCov.start 'rails'
SimpleCov.start do
  add_filter '/lib/'
  add_filter '/vendor/'
  add_group 'Controllers', 'app/controllers'
  add_group 'Models', 'app/models'
  add_group 'Helpers', 'app/helpers'
  add_group 'Mailers', 'app/mailers'
  add_group 'Views', 'app/views'
end

ENV["RAILS_ENV"] ||= 'test'
require File.expand_path("../../config/environment", __FILE__)
require 'rspec/rails'
require 'rspec/autorun'
# Requires supporting ruby files with custom matchers and macros, etc,
# in spec/support/ and its subdirectories.
Dir[Rails.root.join("spec/support/**/*.rb")].each {|f| require f}

RSpec.configure do |config|
  # ## Mock Framework
  #
  # If you prefer to use mocha, flexmock or RR, uncomment the appropriate line:
  #
  # config.mock_with :mocha
  # config.mock_with :flexmock
  # config.mock_with :rr

  # Remove this line if you're not using ActiveRecord or ActiveRecord fixtures
  config.fixture_path = "#{::Rails.root}/spec/fixtures"

  # If you're not using ActiveRecord, or you'd prefer not to run each of your
  # examples within a transaction, remove the following line or assign false
  # instead of true.
  config.use_transactional_fixtures = true

  # If true, the base class of anonymous controllers will be inferred
  # automatically. This will be the default behavior in future versions of
  # rspec-rails.
  config.infer_base_class_for_anonymous_controllers = false

  # Run specs in random order to surface order dependencies. If you find an
  # order dependency and want to debug it, you can fix the order by providing
  # the seed, which is printed after each run.
  #     --seed 1234
  config.order = "random"


   def make_user
     @user = FactoryGirl.create(:user)
     return @user
   end

  def logout
    delete "/user_sessions"
  end
  
   def login_as user
    post "/user_sessions", :user_session=>{:email => user.email, :password => user.password}
  end

  def login 
    make_board
    @user = FactoryGirl.create(:user)
    login_as @user
  end

  def assert_logged_in user
    assert !user.persistence_token.nil?
  end

  def login_as_admin
     @user = FactoryGirl.create(:user)
     @user.role_name = "admin"
     @user.save
     login_as @user
  end

  def login_as_mgt
     @user = FactoryGirl.create(:user)
     @user.role_name = "mgt"
     @user.save
     login_as @user
  end

  def make_board
    @board = Board.default
  end



end
