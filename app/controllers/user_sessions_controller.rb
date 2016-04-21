class UserSessionsController < ApplicationController
  force_ssl
  before_filter :require_user, :only => [:destroy]

  def debug
    @request = request.session_options
  end

  def new
    @user_session = UserSession.new
    @show_popup = true
    render :template=>"posts/index"
  end

  def create
    @user_session = UserSession.new(params[:user_session])

    session[:return_to] = nil
    if @user_session.save
      if @user_session.record.may_login?

        #copy objects in the TempSession to the user
        #note: this causes an error if you delete a car from the admin area
        # temp_session = TempSession.new(request.session_options) 
        # temp_session.copy_to(@user_session.record) #for session objects 
        # if params[:user_session][:cars].present? #for mobile app(sessionless) objects
        #   Car.find(params[:user_session][:cars]).each do |car|
        #     car.copy_to(@user_session.record)
        #   end
        # end

        redirect_to root_url
      else
        flash[:error] =  "Sorry, your access has been blocked."
        out = {:errors=>flash[:access_error]}
        @user_session.destroy
        respond_to do |format|
          format.html { redirect_to root_url }
          format.json { render :json=>out.to_json(:root=>"user")}
        end
      end
    else
      flash[:error] = "Incorrect email or password. Please try again."
      out = {:errors=>@user_session.errors.full_messages}
      respond_to do |format|
        format.html { redirect_to root_url }
        format.json { render :json=>out.to_json(:root=>"user")}
      end
    end
  end

  def destroy
    set_other_user_as_current nil
    current_user.reset_persistence_token
    current_user_session.destroy
    if params[:redirect]
      redirect_to params[:redirect]
    else
      flash[:notice] = "See you later!"
      redirect_to root_url
    end
  end

  def show
    redirect_to root_path
  end


end
