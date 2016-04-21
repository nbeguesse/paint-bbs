class PasswordResetsController < ApplicationController
  ssl_required :create,:update,:edit
  skip_before_filter :require_user,:showroom_viewer_ignore
  before_filter :require_no_user
  before_filter :load_user_using_perishable_token, :only => [:edit, :update]

  def new
    render
  end

  def create
    @user = User.find_by_email(params[:email].try(:downcase))
    if @user
      @user.deliver_password_reset_instructions!
      flash[:notice] = I18n.t( 'emails.reset_password_instructions_sent' )
      redirect_to root_url
    else
      flash[:notice] = I18n.t 'emails.errors.no_user_with_this_email'
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
      flash[:notice] = I18n.t 'emails.password_updated'
      redirect_to root_path
    else
      render :action => :edit
    end
  end

  private

  def load_user_using_perishable_token
    @user = User.find_using_perishable_token(params[:id])
    unless @user
      flash[:notice] = I18n.t 'common.contact_support'
      redirect_to root_url
    end

#  rescue ActiveRecord::RecordNotFound
#
#    flash[:notice] = I18n.t 'common.contact_support'
#      redirect_to root_url
  end
end 