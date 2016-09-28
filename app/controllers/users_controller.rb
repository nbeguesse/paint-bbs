class UsersController < ApplicationController
  #force_ssl

  before_filter :require_user, :only => [:edit, :update]

  def edit
    @user = current_user
    @active_link = "edit_account"
  end

  def update
    
    @user = current_user
    @active_link = "edit_account"
    if @user.update_attributes(params[:user])
      flash[:notice] = "Updated!"
      redirect_to root_url
    else
      flash[:error] = @user.errors.full_messages.first
      render :edit
    end
  end

  def new
    @user = User.new
    @active_link = "new_account"
  end


  def create
    @user = User.new(params[:user])
    @active_link = "new_account"
    if @user.save
        @user_session = UserSession.new(:email=>params[:user][:email], :password=>params[:user][:password])
        @user_session.save #i.e. log them in
        TempSession.new(request.session_options).copy_to(@user) #copy the post over

        reset_session #clear the shopping cart or the items might get added again later
        redirect_to root_url
    else

        flash[:error] = "-- " + @user.errors.full_messages.join('<br/> -- ')
        render :new

    end
  end

  

end
