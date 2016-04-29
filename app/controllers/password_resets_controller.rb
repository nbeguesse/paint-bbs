class PasswordResetsController < ApplicationController
  #ssl_required :create,:update,:edit
  before_filter :require_no_user
  before_filter :load_user_using_perishable_token, :only => [:edit, :update]

  def index
    redirect_to root_url
  end

  def new
    render
  end

  def create
    @user = User.find_by_email(params[:email].try(:downcase))
    if @user
      @user.deliver_password_reset_instructions!
      flash[:notice] = "An e-mail with instructions on resetting your password has been sent."
      redirect_to root_url
    else
      flash[:error] =  "We can not find a user that matches this email address"
      render :action => :new
    end
  end

  def edit
    render
  end

  def update
    @user.password = params[:user][:password]
    @user.password_confirmation = params[:user][:password_confirmation]
    if @user.save
      flash[:notice] = "Your password has been updated, thanks"
      redirect_to root_path
    else
      render :action => :edit
    end
  end

  private

  def load_user_using_perishable_token
    @user = User.find_using_perishable_token(params[:id])
    unless @user
      flash[:notice] = "The link has expired. Please create another password-reset request."
      redirect_to root_url
    end

   rescue ActiveRecord::RecordNotFound

     flash[:notice] = "The link has expired. Please create another password-reset request."
       redirect_to root_url
   end
end 