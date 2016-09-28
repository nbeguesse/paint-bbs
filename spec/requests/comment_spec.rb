require 'spec_helper'
require 'rake'

describe CommentsController do


  it "posts a comment (logged in)" do
    make_post
    get "/comments/new", :post_id=>@post.id
    assert_response :success
    expect {
      post "/comments", :comment=>{:message=>"A belated happy birthday."}, :post_id=>@post.id
    }.to change(Comment, :count).by(1)
    assert_response :redirect
    follow_redirect!
  end

  it "posts a comment (not logged in)" do
    make_post
    logout
    get "/comments/new", :post_id=>@post.id
    assert_response :success
    expect {
      post "/comments", :comment=>{:message=>"A belated happy birthday.", :username=>"John"}, :post_id=>@post.id
    }.to change(Comment, :count).by(1)
    assert_response :redirect
    follow_redirect!
  end  

  it "mgt updates a comment" do
    make_anonymous_comment
    login_as_mgt
    get "/comments/#{@comment.id}/edit"
    assert_response :success #may_edit_comment
    put "/comments/#{@comment.id}", :comment=>{:message=>"(Edited.)"}
    assert_response :redirect
    follow_redirect!

    make_comment
    login_as_mgt
    get "/comments/#{@comment.id}/edit"
    assert_response :success #may_edit_comment
    put "/comments/#{@comment.id}", :comment=>{:message=>"(Edited.)"}
    assert_response :redirect
    follow_redirect!
  end

  it "user updates their own comment" do
    make_comment
    get "/comments/#{@comment.id}/edit"
    assert_response :success #may_edit_comment
    put "/comments/#{@comment.id}", :comment=>{:message=>"(Edited.)"}
    assert_response :redirect
    follow_redirect!
  end

  it "mgt deletes anoymous comment" do
    make_anonymous_comment
    login_as_mgt
     expect{
       delete "/comments/#{@comment.id}"
     }.to change(Comment, :count).by(-1)
  end
  it "mgt deletes a comment" do
    make_comment
    login_as_mgt
    expect{
       delete "/comments/#{@comment.id}"
    }.to change(Comment, :count).by(-1)
  end

  it "user can't delete others comment" do
    make_comment
    login
     expect{
       delete "/comments/#{@comment.id}"
     }.to change(Comment, :count).by(0)
     assert_response :redirect
  end

  it "user can't edit others comment" do
    make_comment
    login
    put "/comments/#{@comment.id}", :comment=>{:message=>"(Edited.)"}
    assert_response :redirect
  end

  it "can't take another user's name" do
    make_comment
    logout
    expect{
      post "/comments", :comment=>{:message=>"A belated happy birthday.", :username=>@user.name}, :post_id=>@post.id
    }.to change(Comment, :count).by(0)
    assert flash[:error].present?
    assert assigns(:comment).errors.messages[:username]
  end

  it "notifies users of a comment" do
    expect{
      #notifies users of a comment on my post
      make_anonymous_comment
    }.to change(ActionMailer::Base.deliveries, :length).by(1)
    logout
    expect{
      #additional comments not emailed until you check
      expect{
        post "/comments", :comment=>{:message=>"A belated happy birthday.", :username=>"Mary"}, :post_id=>@post.id
      }.to change(Comment, :count).by(1)
    }.to change(ActionMailer::Base.deliveries, :length).by(0)
  end

  it "denies if blank field is filled" do
    make_post
    logout
    expect{
        post "/comments", :comment=>{:message=>"A belated happy birthday.", :username=>"Mary", :blank_field=>"Hi!"}, :post_id=>@post.id
    }.to change(Comment, :count).by(0)
  end
  it "denies if URLS in text field" do
    make_post
    logout
    expect{
        post "/comments", :comment=>{:message=>"http://www.google.com", :username=>"Mary"}, :post_id=>@post.id
    }.to change(Comment, :count).by(0)
  end

  it "bounces you back on update error" do
    make_comment
    get "/comments/#{@comment.id}/edit"
    assert_response :success #may_edit_comment
    put "/comments/#{@comment.id}", :comment=>{:message=>""}
    assert_response :success
    assert flash[:error].present?
    assert assigns(:comment).errors.messages[:message]
  end

private
  def make_post
    login
    @post = FactoryGirl.create(:post, :user_id=>@user.id, :user_type=>"User", :board_id=>@board.id)
  end

  def make_comment
    @post || make_post
    logout
    login
    post "/comments", :comment=>{:message=>"A belated happy birthday."}, :post_id=>@post.id
    @comment = Comment.last
  end

  def make_anonymous_comment
    @post || make_post
    logout
    post "/comments", :comment=>{:message=>"A belated happy birthday.", :username=>"John"}, :post_id=>@post.id
    @comment = Comment.last
  end

end