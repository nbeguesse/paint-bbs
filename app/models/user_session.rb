class UserSession < Authlogic::Session::Base
#  find_by_login_method :find_by_email
  login_field :email
  cookie_key "paint#{Rails.env[0..0]}_user_key"

end