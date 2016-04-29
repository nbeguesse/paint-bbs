class Comment < ActiveRecord::Base
  attr_accessor :blank_field
  attr_accessible :ip_address, :message, :username, :blank_field
  validates_presence_of [:post, :user_id, :user_type, :message, :ip_address]
  validates_presence_of :username, :if=>:temp_user?
  validate :blank_field_is_blank
  belongs_to :post

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

  def blank_field_is_blank
    if blank_field.present?
      errors.add :blank_field, "must be blank"
    end
  end


end
