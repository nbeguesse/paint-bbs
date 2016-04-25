module Authentication
  def self.included(controller)
    controller.send :helper_method, :current_user_session, :current_user, :logged_in?, :current_actual_user

  end

  def current_user_session
    return @current_user_session if defined?(@current_user_session)
    @current_user_session = UserSession.find
  end

  def logged_in?
    current_user.present?
  end

  def current_user
    return @current_user if defined?(@current_user)
    return unless current_user_session.present?

    @current_user = current_user_session.user

    @current_user
  end

  def current_actual_user
    return @current_actual_user if defined?(@current_actual_user)
    @current_actual_user = current_user_session.user if current_user_session
  end


  def require_user
    unless current_user

      flash[:error] = "Please login or sign up to continue."
      redirect_to new_user_url

    end
  end

  def require_admin
    unless (current_user && current_user.admin?)
      flash[:error] = "Please login as an admin to do that. Role: #{current_user.role_name} id: #{current_user.id}"
      redirect_to new_user_url
    end
  end


  def require_no_user
    if current_user
      store_location
      flash[:error] = "Please logout first. The link is at the bottom of the page."
      redirect_to root_url
      return false
    end
  end

  def store_location
    session[:return_to] =
    if request.get?
      request.fullpath
    else
      request.referer
    end
  end

  def redirect_back_or_default(default, *options)
    return_to = session[:return_to]
    session[:return_to] = nil
    tag_options = {}
    options.first.each { |k,v| tag_options[k] = v } unless options.empty?
    redirect_to(return_to || request.headers["Referer"] || default, tag_options)
  end


  def may_edit_comment
    if @comment
      unless current_user && current_user.may_edit_comment?(@comment)
        flash[:error] = "Please login as a moderator to do that."
        redirect_to new_user_url
      end
    end
  end

  def may_delete_comment
    if @comment
      unless current_user && current_user.may_delete_comment?(@comment)
        flash[:error] = "Please login as a moderator to do that."
        redirect_to new_user_url
      end
    end
  end

  def may_edit_post
    if @post
      unless session_obj.may_edit_post?(@post)
        flash[:error] = "Please login as a moderator to do that."
        redirect_to new_user_url
      end
    end
  end
end

