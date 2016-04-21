class User < ActiveRecord::Base
  attr_accessible :email, :name

  PATH = '/avatars/:id/:style.:extension'
  opts =
        {
          :path => ':rails_root/public' + PATH,
          :url => PATH,
          :default_url => '/images/missing-car/:style.jpg',
          :styles => { :small => "x50", :medium => "x150" }
          }
  has_attached_file :avatar, opts
end
