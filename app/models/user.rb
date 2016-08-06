class User < ActiveRecord::Base
  attr_accessible :email, :name, :password, :avatar, :notify_on_new_post, :notify_on_new_comments
  validates_presence_of :name
  validates_presence_of :email
  validates_uniqueness_of :email
  validates_uniqueness_of :name
  scope :notifiable_on_post, :conditions => {:notify_on_new_post => 'true'}  
  scope :notifiable_on_comment, :conditions => {:notify_on_new_comments => 'true'}  
  PATH = '/avatars/:id/:style.:extension'
  opts =  { :path => ':rails_root/public' +PATH,
            :url => PATH,
            :bucket=>Settings.storage_bucket,
          }.merge(Settings.storage_settings)

  has_attached_file :avatar, opts

  acts_as_authentic do |config|
    config.login_field :email
    config.validate_login_field false
    config.validates_length_of_password_confirmation_field_options :minimum => 0, :if => :require_password?
    config.crypto_provider = Authlogic::CryptoProviders::BCrypt
    config.transition_from_crypto_providers = Authlogic::CryptoProviders::Sha512
  end

  def may_continue_post? post
    #only the artist can continue posts because the url's get weird when mgts do it
    admin? || post.user_id == self.id.to_s
  end

  def may_edit_post? post
    mgt? || post.user_id == self.id.to_s
  end

  def may_edit_comment? comment
    mgt? || comment.user_id == self.id.to_s
  end

  def may_delete_comment? comment
    mgt? 
  end

  def may_login?
    !self.blocked
  end

  def posts
    Post.where(:user_id=>self.id.to_s)
  end 

  def work_in_progress
    posts.where(:in_progress=>true).first
  end

   def deliver_password_reset_instructions!
     reset_perishable_token!
     Mailer.password_reset_instructions( self.email, self.perishable_token).deliver!
   end

   def admin?
    (role_name == "admin")
   end

   def mgt?
    admin? || role_name == "mgt"
   end

end
