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

  it "updates a comment" do
    make_comment
    login_as_mgt
    get "/comments/#{@comment.id}/edit"
    assert_response :success #may_edit_comment
    put "/comments/#{@comment.id}", :comment=>{:message=>"(Edited.)"}
    assert_response :redirect
    follow_redirect!
  end

  it "deletes a comment" do
    make_comment
    login_as_mgt
     expect{
       delete "/comments/#{@comment.id}"
     }.to change(Comment, :count).by(-1)
  end

  it "notifies users of a comment" do
    expect{
      make_comment
    }.to change(ActionMailer::Base.deliveries, :length).by(1)
    expect{
      @comment = @post.comments.new(:username=>"Mary", :message=>"A new comment from a not logged-in user")
      @comment.user_type = "TempSession"
      @comment.user_id = "1111"
      @comment.ip_address = "127.0.0.1"
      @comment.save!
    }.to change(ActionMailer::Base.deliveries, :length).by(0)
  end

private
  def make_post
    login
    @post = FactoryGirl.create(:post, :user_id=>@user.id, :user_type=>"User", :board_id=>@board.id)
  end

  def make_comment
    make_post
    logout
    @comment = @post.comments.new(:username=>"Mary", :message=>"A new comment from a not logged-in user")
    @comment.user_type = "TempSession"
    @comment.user_id = "1111"
    @comment.ip_address = "127.0.0.1"
    @comment.save!
  end

end