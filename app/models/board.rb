class Board < ActiveRecord::Base
  validates_presence_of [:name, :slug]
  attr_accessible :name, :slug
  has_many :posts

  def self.default
    self.find_by_slug("general") || self.create(:name=>"General Board", :slug=>"general")
  end

  def self.faq
    self.find_by_slug("faq") || self.create(:name=>"FAQ", :slug=>"faq")
  end

  def faq?
    self == Board.faq
  end

end
