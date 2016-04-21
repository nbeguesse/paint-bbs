class User < ActiveRecord::Base
  attr_accessible :email, :name, :password
  validates_presence_of :name
  validates_presence_of :email
  validates_uniqueness_of :email

  PATH = '/avatars/:id/:style.:extension'
  opts =
        {
          :path => ':rails_root/public' + PATH,
          :url => PATH,
          :default_url => '/images/missing-car/:style.jpg',
          :styles => { :small => "x50", :medium => "x150" }
          }
  has_attached_file :avatar, opts

  acts_as_authentic do |config|
    config.login_field :email
    config.validate_login_field false
    config.validates_length_of_password_confirmation_field_options :minimum => 0, :if => :require_password?
    config.crypto_provider = Authlogic::CryptoProviders::BCrypt
    config.transition_from_crypto_providers = Authlogic::CryptoProviders::Sha512
  end
end
