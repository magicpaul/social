require 'test_helper'

class ProfilesControllerTest < ActionController::TestCase
  test "should get show" do
    get :show, id: users(:paul).profile_name
    assert_response :success
    assert_template 'profiles/show'
  end
  test "should show 404 if not found" do
  	 get :show, id:"blank"
  	 assert_response :not_found
  end

  test "variables are passed" do
  	get :show, id: users(:paul).profile_name
    assert assigns(:user)
    assert_not_empty assigns(:statuses)
  end

  test "only shows the correct statuses" do
    get :show, id: users(:paul).profile_name
    assigns(:statuses).each do |status|
      assert_equal users(:paul), status.user
    end
  end
end
