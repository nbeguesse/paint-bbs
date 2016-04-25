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

  def mail_test(email)
    Rails.logger.info "some delayed test"
    set_category("Test Email")
    subject = "Test mail"
    mail(:to => email, :subject => subject)
  end
  
  protected

  def set_category(category)
    h = { 'category' => category}
    headers "X-SMTPAPI" => h.to_json
  end

end
