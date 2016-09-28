require 'spec_helper'

describe PasswordResetsController do

  it "odds and ends" do
    get "/password_resets"
    assert_response :redirect
    get "/password_resets/new"
    assert_response :success
    login
    get "/password_resets/new"
    assert_response :redirect 
  end

  it "sends forgot password email" do
    @user = FactoryGirl.create(:user)
    expect {
      post "/password_resets", :email=>@user.email
      assert_response :redirect
    }.to change(ActionMailer::Base.deliveries, :length).by(1)
  end

  it "redirects if email is not found" do
    expect {
      post "/password_resets", :email=>"test_hls@mailinator.com"
      assert_response :success
    }.to change(ActionMailer::Base.deliveries, :length).by(0)
  end

  it "follows the password reset link" do
    @user = FactoryGirl.create(:user)
    
    post "/password_resets", :email=>@user.email
    @user.reload

    get "/password_resets/#{@user.perishable_token}/edit"
    assert_response :success
  end

  it "expires the password reset link" do
    @user = FactoryGirl.create(:user)
    
    post "/password_resets", :email=>@user.email
    @old_token = @user.perishable_token
    post "/password_resets", :email=>@user.email
    @user.reload

    get "/password_resets/#{@old_token}/edit"
    assert_response :redirect

  end

  it "resets the password" do
    new_pass = "NEW_PASSWORD"
    @user = FactoryGirl.create(:user)
    post "/password_resets", :email=>@user.email
    @user.reload
    put "/password_resets/#{@user.perishable_token}", :user=>{:password=>new_pass, :password_confirmation=>new_pass}
    assert_response :redirect
    logout
    post "/user_sessions", :user_session=>{:email => @user.email, :password => new_pass}
    assert_logged_in @user
  end

  it "gives you another chance if you can't even reset the password right" do
    new_pass = "NEW_PASSWORD"
    @user = FactoryGirl.create(:user)
    post "/password_resets", :email=>@user.email
    @user.reload
    put "/password_resets/#{@user.perishable_token}", :user=>{:password=>new_pass, :password_confirmation=>"old_pass"}
    assert_response :success
    assert flash[:error].present?

  end


end