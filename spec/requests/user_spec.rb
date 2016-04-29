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

  it "edits a user" do
    login
    get "/users/#{@user.id}/edit"
    assert_response :success
  end

  it "updates a user and uploads avatar" do
    login
    #upload avatar
    file = Rack::Test::UploadedFile.new(Rails.root.join('spec/fixtures/images/avatar1.jpg'), 'image/jpg')
    put "/users/#{@user.id}", :user=>{:name=>"Name2", :email=>"email@hotmail.com", :avatar=>file}
    assert_response :redirect
    assert @user.reload.avatar.present?   
    get "/users/#{@user.id}/edit" #show avatar
    assert_response :success 
  end




end