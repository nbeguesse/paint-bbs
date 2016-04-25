#this is just a container for holding cars before the user has logged in.
class TempSession

  def self.destroy_all
    Post.where(["owner_type = ?",self.to_s]).destroy_all
  end

  def self.scoped
    self
  end 
  
  def self.find(num, options)
    nil
  end

  def initialize(options)
    if Rails.env.test? 
      @options = {:id=>TempSession.test_id}
    else
  	  @options = options
    end
  end

  def self.test_id
    "1234"
  end

  def id
  	@options[:id]
  end

  def posts
    Post.where(:user_id=>self.id.to_s)
  end 

  def work_in_progress
    posts.where(:in_progress=>true).first
  end

  def may_edit_post? post
    post.user_id == self.id.to_s
  end

  def copy_to(user)
    posts.each do |post|
      post.copy_to(user)
    end
  end


end