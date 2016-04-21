class UsersController < ApplicationController
  # ssl_allowed :destroy
  # ssl_required :create, :update, :edit
  force_ssl #:except=>[:new]

  before_filter :require_user, :only => [:edit, :update]

  def edit
    @user = current_user
  end

  def update
    #TODO: copy params
    current_user.save
    redirect_to root_url
  end

  def new
    @user = User.new
  end


  def create
    @user = User.new(params[:user])

    if @user.save
        @user_session = UserSession.new(:email=>params[:user][:email], :password=>params[:user][:password])
        @user_session.save #i.e. log them in
        #TempSession.new(request.session_options).copy_to(@user) #copy the shopping cart over

        reset_session #clear the shopping cart or the items might get added again later
        redirect_to root_url
    else

        flash[:error] = "-- " + @user.errors.full_messages.join('<br/> -- ')
        redirect_to new_user_url

    end
  end

  def index
    @users = User.paginate({:page=>1})
  end


  def change_password
    @user = User.find params[:id]
    User.transaction do
      unless @user.update_attributes(params[:user])
        flash[:error] = error_messages_as_string @user
      end
    end
    redirect_to :back
  end
  

end
