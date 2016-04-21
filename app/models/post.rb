class Post < ActiveRecord::Base
  attr_accessible :message, :title

  IMG_PATH = '/images/:id/:style.:extension'
  ANIM_PATH = '/anim/:id/:style.:extension'

  has_attached_file :image, {
          :path => ':rails_root/public' + IMG_PATH,
          :url => IMG_PATH,
          :default_url => '/images/missing-car/:style.jpg',
          :styles => { :small => "x50", :medium => "x150" }
          }
  has_attached_file :anim, {
          :path => ':rails_root/public' + ANIM_PATH,
          :url => ANIM_PATH
          }
end
