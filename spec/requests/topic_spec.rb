require 'spec_helper'
require 'rake'

describe TopicsController do

  it "gets index" do
    make_topic
    get topics_path
  end

  it "shows a topic" do
    login_as_mgt
    make_topic
    get topic_path(@topic)
    assert_response :success
    get topic_path("some fake id")
    assert_response :redirect
  end

  it "creates a new topic" do
    login_as_mgt
    get new_topic_path
    expect {
      post "/topics", :topic=>{:name=>"My Topic!"}
    }.to change(Topic, :count).by(1)
  end

  it "edits a topic" do
    login_as_mgt
    make_topic
    get edit_topic_path(@topic)
    put topic_path(@topic), :topic=>{:name=>"Edited Topic."}
    assert_equal @topic.reload.name, "Edited Topic."
  end

  it "deletes a topic" do
    login_as_mgt
    make_topic
    expect{
       delete "/topics/#{@topic.id}"
    }.to change(Topic, :count).by(-1)
  end

  it "can't create if topic is taken" do
    login_as_mgt
    already = make_topic
    expect {
      post "/topics", :topic=>{:name=>already.name}
    }.to change(Topic, :count).by(0)
    assert_response :success
    assert flash[:error].present?
    assert assigns(:topic).errors.messages[:name]
  end

  it "can't update if topic is taken" do
    login_as_mgt
    first = FactoryGirl.create(:topic, :name=>"Example")
    second = FactoryGirl.create(:topic, :name=>"Example2")
    put topic_path(first), :topic=>{:name=>second.name}
    assert_response :success
    assert flash[:error].present?
    assert assigns(:topic).errors.messages[:name]
  end

  it "requires mgt to change a topic" do
    make_topic
    expect{
       delete "/topics/#{@topic.id}"
    }.to change(Topic, :count).by(0)
  end


private
  def make_topic
    @topic = FactoryGirl.create(:topic)
  end
end