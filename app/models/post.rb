class Post < ActiveRecord::Base
  attr_accessible :message, :title, :paint_time, :in_progress, :username, :image, :is_upload, :uploaded_art, :faq_category
  belongs_to :board
  validates_presence_of [:board,:user_id,:user_type]
  validates_presence_of [:title, :message], :unless=>:in_progress?
  #validates_length_of :message, :minimum=>20, :unless=>:in_progress?, :too_short=>"is too short. Write more!"
  validates_presence_of :username, :if=>:temp_user?, :unless=>:in_progress?
  validate :enough_paint_time
  validate :unique_username
  before_save :set_slug
  scope :finished, :conditions => {:in_progress => false}
  has_many :comments, :order=>"id asc"
  after_create :notify_users

  IMG_PATH = '/posts/:board_id/:id_:style.:ext'
  #.CHI is not an animation file, just layer info
  ANIM_PATH = '/anim/:board_id/:id.chi' 
  PALETTE_PATH = '/palettes/:board_id/:id.aco'

  has_attached_file :image, { :path => ':rails_root/public' +IMG_PATH,
            :url => IMG_PATH,
            :bucket=>Settings.storage_bucket,
          }.merge(Settings.storage_settings)
  has_attached_file :anim, { :path => ':rails_root/public' +ANIM_PATH,
            :url => ANIM_PATH,
            :bucket=>Settings.storage_bucket,
          }.merge(Settings.storage_settings(false))
  has_attached_file :palette, { :path => ':rails_root/public' +PALETTE_PATH,
            :url => PALETTE_PATH,
            :bucket=>Settings.storage_bucket,
          }.merge(Settings.storage_settings(false))

  def notify_users
    User.notifiable_on_post.each do |temp_user|
      next if temp_user.id == user_id
      begin
        Mailer.notify_on_post(temp_user.id, id).deliver!
      rescue Exception=>e
        if Rails.env.development?
          raise e
        end
      end
    end
  end

  def already_finished?
    id && !in_progress?
  end

  def creator
    username || user.try(:name) || "Anonymous"
  end

  def user
    if user_type == "User"
      User.find_by_id(user_id)
    end
  end


  def temp_user?
    user_type == "TempSession"
  end

  def load_image_url
    return image.url if image.present?
  end

  def load_chibi_file_url
    return anim.url if anim.present?
  end

  def load_swatches_url
    return palette.url if palette.present?
  end

  def copy_to(user)
    return nil unless user
    self.user_id = user.id
    self.user_type = user.class.to_s
    self.save!   
  end

  def set_slug
    if slug.blank? && title.present?
      self.slug = "#{id} #{title}".parameterize
    end
  end

  def self.faq_keys
    {"help"=>"Technical Help", "howto"=>"How to Do Everything", "rules"=>"The Rules and Rule-breaking"}
  end

protected

def helpers
  ActionController::Base.helpers
end

  def enough_paint_time
    if paint_time && !in_progress?
      if paint_time < Settings.min_paint_time
        errors.add :paint_time, "is too short. Click <a href='/boards/#{board_id}/posts/doodle'>doodle</a> and draw some more! (Limit is #{helpers.distance_of_time_in_words(Settings.min_paint_time)})".html_safe
      end
    end
  end

  def unique_username
    if username
      if User.find_by_name(username)
        errors.add :username, "is taken"
      end
    end
  end



 end
