class ApplicationController < ActionController::Base
  protect_from_forgery
  helper :all 
  before_filter :set_request
  # include ::SslRequirement

  helper_method :secure?, :session_obj, :post_path, :new_post_path, :edit_post_path, :doodle_path, :current_user_session, :current_user, :logged_in?, :current_actual_user
  def secure?
    Rails.env.production?
  end

  def set_request
    @request = request
  end

   def session_obj
    #for logged in user
    return current_user if logged_in? 
    #for non-logged in user
    TempSession.new(request.session_options) 
  end

  def generate_post(user, options={})
    post = @board.posts.new(options)
    post.user_type = user.class.to_s
    post.user_id = user.id
    post.ip_address = request.remote_ip
    return post
  end

  def generate_comment(user, options={})
    comment = @post.comments.new(options)
    comment.user_type = user.class.to_s
    comment.user_id = user.id
    comment.ip_address = request.remote_ip
    return comment
  end

  def post_path(post)
    board_post_path(post.board, post)
  end

  def edit_post_path post
    edit_board_post_path(post.board, post)
  end

  def new_post_path
    new_board_post_path(@board || Board.default)
  end

  def doodle_path post=nil
    if post
      doodle_board_post_path(post.board, post)
    else
      doodle_board_posts_path(@board || Board.default)
    end
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


  def require_user
    unless current_user

      flash[:error] = "Please login or sign up to continue."
      redirect_to new_user_url

    end
  end


  def require_no_user
    if current_user
      flash[:error] = "Please logout first. The link is at the bottom of the page."
      redirect_to root_url
      return false
    end
  end





   
end
