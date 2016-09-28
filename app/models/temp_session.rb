#this is just a container for holding cars before the user has logged in.
class TempSession

  
  def self.find(num, options)
    nil
  end

  def initialize(options)
    @options = Rails.env.test? ? {:id=>TempSession.test_id} : options
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