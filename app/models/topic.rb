class Topic < ActiveRecord::Base
  attr_accessible :name
  validates_uniqueness_of :name
  validates_presence_of :name
end
