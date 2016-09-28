require 'spec_helper'
require 'rake'

describe PagesController do
  fixtures :posts

  it "gets some pages" do
    #reset board ids so FAQ posts fo to correct board
    Board.connection.execute("TRUNCATE boards RESTART IDENTITY")
    Board.default
    Board.faq
    get "/pages/faq"
    assert_response :success
    get "/pages/privacy"
    assert_response :success
  end



end