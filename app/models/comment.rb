class Comment < ActiveRecord::Base
  attr_accessor :blank_field
  attr_accessible :ip_address, :message, :username, :blank_field
  validates_presence_of [:post, :user_id, :user_type, :message, :ip_address]
  validates_presence_of :username, :if=>:temp_user?
  validate :username_is_not_taken, :if=>:temp_user?
  validate :no_spam, :if=>:temp_user?
  belongs_to :post
  before_create :notify_users

  def notify_users
    if post.user && post.user.notify_on_new_comments
      if user_id != post.user_id
        Mailer.notify_on_comment(post.user_id, post.id).deliver!
      end
    end
  end

  def temp_user?
    user_type == "TempSession"
  end

  def user
    if user_type == "User"
      User.find_by_id(user_id)
    end
  end

  def creator
    username || user.try(:name) || "Anonymous"
  end

  def username_is_not_taken
    if User.find_by_name(username)
      errors.add :username, "is already taken."
    end
  end


  def no_spam
    if message && message.include?("http")
      errors.add :message, "cannot include URLs."
    end
    if blank_field.present?
      errors.add :blank_field, "must be blank"
    end
  end


end
