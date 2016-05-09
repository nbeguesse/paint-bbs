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
    subject = "A new post has been made on #{Settings.host}"
    set_category "transactional"
    @user = User.find(user_id)
    @post = Post.find(post_id)
    mail(:to => @user.email, :subject => subject)
  end
  
  def notify_on_comment(user_id, post_id)
    subject = "Someone commented on your post!"
    set_category "transactional"
    @post = Post.find(post_id)
    @user = User.find(user_id)
    mail(:to => @user.email, :subject => subject)
  end

  protected

  def set_category(category)
    h = { 'category' => category}
    headers "X-SMTPAPI" => h.to_json
  end

end
