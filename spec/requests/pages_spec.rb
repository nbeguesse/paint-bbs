require 'spec_helper'
require 'rake'

describe PagesController do

  it "gets some pages" do
    get "/pages/faq"
    assert_response :success
    get "/pages/privacy"
    assert_response :success
  end



end