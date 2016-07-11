require 'spec_helper'
require 'rake'

describe PostsController do

  it "doodles and safety saves an image (not logged in)" do
    @email_user = FactoryGirl.create(:user)
    make_board
    get "/boards/#{@board.id}/posts/doodle"
    assert_response :success
    @paint = assigns(:paint)
    make_uploaded_files
    expect {
      saveUrl = URI.parse(@paint["saveUrl"]).path #strip the start_time parameter
      post saveUrl, {"picture"=>@picture, "chibifile"=>@chibifile, "rotation"=>"0", "swatches"=>@swatches, "started_at"=>20.minutes.ago.to_i, "board_id"=>"1"}
    }.to change(Post, :count).by(1)

    #we've saved it, now get the doodlepath again (the saveUrl should change)
    get "/boards/#{@board.id}/posts/doodle"
    @paint = assigns(:paint)
    saveUrl = URI.parse(@paint["saveUrl"]).path #now the saveURL has the post ID
    post saveUrl, {"picture"=>@picture, "chibifile"=>@chibifile, "rotation"=>"0", "swatches"=>@swatches, "started_at"=>3.minutes.ago.to_i, "board_id"=>"1"}

    #finish the pic
    expect{
      get @paint["postUrl"]
      assert_response :success
      @post = Post.last
      assert @post.in_progress
      put "/boards/#{@board.id}/posts/#{@post.id}", :post=>{:title=>"My first post", :message=>"A belated happy birthday message.", :username=>"Bunny"}
      assert_response :redirect
      assert !@post.reload.in_progress
      #look at the finished pic
      follow_redirect!
      assert_response :success
    }.to change(ActionMailer::Base.deliveries, :length).by(1)  
  end

  it "doodles and safety saves an image (logged in)" do
    login
    get "/boards/#{@board.id}/posts/doodle"
    assert_response :success
    @paint = assigns(:paint)
    make_uploaded_files
    expect {
      saveUrl = URI.parse(@paint["saveUrl"]).path #strip the start_time parameter
      post saveUrl, {"beginMarker"=>"This marker ensures the upload wasn't truncated", "picture"=>@picture, "chibifile"=>@chibifile, "rotation"=>"0", "swatches"=>@swatches, "endMarker"=>"This marker ensures the upload wasn't truncated", "started_at"=>20.minutes.ago.to_i, "board_id"=>"1"}
    }.to change(Post, :count).by(1)
    #finish the pic
    get @paint["postUrl"]
    assert_response :success
    @post = Post.last
    assert @post.in_progress
    put "/boards/#{@board.id}/posts/#{@post.id}", :post=>{:title=>"My first post", :message=>"A belated happy birthday message."}
    assert_response :redirect
    assert !@post.reload.in_progress
    #look at the finished pic
    follow_redirect!
    assert_response :success
  end

  it "displays a post with avatar/moderator" do
    make_board
    login_as_admin
    file = Rack::Test::UploadedFile.new(Rails.root.join('spec/fixtures/images/avatar1.jpg'), 'image/jpg')
    put "/users/#{@user.id}", :user=>{:avatar=>file}
    FactoryGirl.create(:post, :user_id=>@user.id, :user_type=>@user.class, :board_id=>@board.id)
    get "/boards/#{@board.id}"
    assert_response :success
  end

  it "uploads a file" do
    @email_user = FactoryGirl.create(:user)
    login
    get "/boards/#{@board.id}/posts/upload"
    assert_response :success
    expect {
      expect {
        file = Rack::Test::UploadedFile.new(Rails.root.join('spec/fixtures/images/avatar1.jpg'), 'image/jpg')
        post "/boards/#{@board.id}/posts", :post=>{:image=>file, :title=>"My title", :message=>"A belated happy birthday."}
      }.to change(Post, :count).by(1)
    }.to change(ActionMailer::Base.deliveries, :length).by(1)  
    @post = Post.last
    assert @post.paint_time.nil?
    assert !@post.in_progress?
    #Now trace over it
    get "/boards/#{@board.id}/posts/#{@post.id}/doodle"
    @paint = assigns(:paint)
    make_uploaded_files
    expect {
      post @paint["saveUrl"], {"picture"=>@picture, "chibifile"=>@chibifile, "rotation"=>"0", "swatches"=>@swatches, "started_at"=>20.minutes.ago.to_i, "board_id"=>"1"}
    }.to change(Post, :count).by(0) #same slot!
    assert @post.reload.paint_time.nil?
  end


  it "deletes a post" do
    make_finished_post
    login_as_mgt
     expect{
       delete "/boards/#{@board.id}/posts/#{@post.id}"
     }.to change(Post, :count).by(-1)
  end

  it "edits someone else's (finished already)" do
    make_finished_post
    login_as_mgt
    get "/boards/#{@board.id}/posts/#{@post.id}/edit"
    assert_response :success
    put "/boards/#{@board.id}/posts/#{@post.id}", :post=>{:title=>"Edited post"}
    assert_response :redirect
    assert_equal @post.reload.title, "Edited post"
    #don't continue in this situation, it's too weird
  end

  it "transfers a pic (login)" do
    make_board
    get "/boards/#{@board.id}/posts/doodle"
    make_uploaded_files
    expect {
      post assigns(:paint)["saveUrl"], {"picture"=>@picture, "chibifile"=>@chibifile, "rotation"=>"0", "swatches"=>@swatches, "started_at"=>20.minutes.ago.to_i, "board_id"=>"1"}
    }.to change(Post, :count).by(1)

    login
    assert @user.posts.count > 0
  end

  it "transfers a pic (new account)" do
    make_board
    get "/boards/#{@board.id}/posts/doodle"
    make_uploaded_files
    expect {
      post assigns(:paint)["saveUrl"], {"picture"=>@picture, "chibifile"=>@chibifile, "rotation"=>"0", "swatches"=>@swatches, "started_at"=>20.minutes.ago.to_i, "board_id"=>"1"}
    }.to change(Post, :count).by(1)

    email = "testuser00070@mailinator.com"
    attributes = FactoryGirl.attributes_for(:user).merge(:email=>email)
      expect {
        post "/users", :user=>attributes
      }.to change(User, :count).by(1)
    assert User.last.posts.count > 0
  end

  it "shows finished post" do
    make_finished_post
    get "/posts/#{@post.slug}"
    assert_response :success
  end


private
  def make_finished_post
    login
    @post = FactoryGirl.create(:post, :user_id=>@user.id, :user_type=>@user.class, :board_id=>@board.id)
  end

  def make_uploaded_files
    @picture = Rack::Test::UploadedFile.new(Rails.root.join('spec/fixtures/images/29.png'))
    @chibifile = Rack::Test::UploadedFile.new(Rails.root.join('spec/fixtures/images/29.chi'))
    @swatches = Rack::Test::UploadedFile.new(Rails.root.join('spec/fixtures/images/29.aco'))
  end

end