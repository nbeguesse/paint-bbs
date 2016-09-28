require 'spec_helper'
require 'rake'

describe UsersController do

  it "shows new form" do
    get "/users/new"
    assert_response :success
  end

  it "creates a user" do
    email = "testuser00069@mailinator.com"
    attributes = FactoryGirl.attributes_for(:user).merge(:email=>email)
    expect {
      post "/users", :user=>attributes
    }.to change(User, :count).by(1)
    assert_response :redirect
    get "/"
    assert_response :success
  end

  it "bounces if your name is taken" do
    @user = FactoryGirl.create(:user)
    expect {
      post "/users", :user=>{:name=>@user.name, :email=>"my@gmail.com", :password=>"1234"}
    }.to change(User, :count).by(0)  
    assert flash[:error].present? #i.e. Name has already been taken
    assert_response :success  
  end

  it "edits a user and uploads avatar" do
    login
    get "/users/#{@user.id}/edit"
    assert_response :success
    #upload avatar
    file = Rack::Test::UploadedFile.new(Rails.root.join('spec/fixtures/images/avatar1.jpg'), 'image/jpg')
    put "/users/#{@user.id}", :user=>{:name=>"Name2", :email=>"email@hotmail.com", :avatar=>file}
    assert_response :redirect
    assert @user.reload.avatar.present?   
    get "/users/#{@user.id}/edit" #show avatar
    assert_response :success 
  end

  it "bounces on incorrect edit" do
    login
    already = @user
    login
    put "/users/#{@user.id}", :user=>{:name=>already.name}
    assert flash[:error].present?
    assert_response :success

  end

  it "bounces on incorrect login" do
    @user = FactoryGirl.create(:user)
    post "/user_sessions", :user_session=>{:email => @user.email, :password => "(Wrong password)"}
    assert_response :redirect
    assert flash[:error].present?
  end

  it "bounces if you are blocked" do
    @user = FactoryGirl.create(:user)
    @user.update_attribute(:blocked, true)
    post "/user_sessions", :user_session=>{:email => @user.email, :password=>@user.password}
    assert_response :redirect
    assert flash[:error].present?
  end

end