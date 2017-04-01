require 'test_helper'

class GroupPollsControllerTest < ActionController::TestCase
  test "should get index" do
    get :index
    assert_response :success
  end

  test "should get create" do
    get :create
    assert_response :success
  end

  test "should get vote" do
    get :vote
    assert_response :success
  end

  test "should get result" do
    get :result
    assert_response :success
  end

end
