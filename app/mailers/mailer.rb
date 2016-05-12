class Mailer < ActionMailer::Base
  layout 'email'
  default :from => "Angelboy Info <info@angelboy.com>"
  default :content_type=>"text/html"


  def password_reset_instructions(email, token)
    subject = "Password reset request"
    set_category("password_reset_instructions")
    @edit_password_reset_url = edit_password_reset_url(token)
    mail(:to => email, :subject => subject)
  end

  def notify_on_post(user_id, post_id)
    @user = User.find(user_id)
    unless @user.last_emailed_at_post.to_f > @user.last_request_at.to_f
      subject = "A new post has been made on #{Settings.host}"
      set_category "transactional"
      
      @post = Post.find(post_id)
      mail(:to => @user.email, :subject => subject)
      @user.update_attribute(:last_emailed_at_post, Time.now)
    end
  end
  
  def notify_on_comment(user_id, post_id)
    @user = User.find(user_id)
    unless @user.last_emailed_at_comment.to_f > @user.last_request_at.to_f
      subject = "Someone commented on your post!"
      set_category "transactional"
      @post = Post.find(post_id)
      mail(:to => @user.email, :subject => subject)
      @user.update_attribute(:last_emailed_at_comment, Time.now)
    end
  end

  protected

  def set_category(category)
    h = { 'category' => category}
    headers "X-SMTPAPI" => h.to_json
  end

end
