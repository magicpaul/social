require 'test_helper'

class StatusesControllerTest < ActionController::TestCase
  setup do
    @status = statuses(:one)
  end

  test "should be redirected when not logged in" do
    get :new
    assert_response :redirect
    assert_redirected_to new_user_session_path
  end

  test "should get new when logged in" do
    sign_in users(:paul)
    get :new
    assert_response :success
  end

  test "should be logged in to post a status" do
    post :create, status: { content: "test" }
    assert_response :redirect
    assert_redirected_to new_user_session_path
  end

  test "should create status when logged in" do
    sign_in users(:paul)
    assert_difference('Activity.count') do
      post :create, status: { content: @status.content }
    end
  end

  test "should create an activity item for status when logged in" do
    sign_in users(:paul)
    assert_difference('Activity.count') do
      post :create, status: { content: @status.content }
    end

    assert_redirected_to status_path(assigns(:status))
  end

  test "should create status for current user when logged in" do
    sign_in users(:paul)
    assert_difference('Status.count') do
      post :create, status: { content: @status.content, user_id: users(:laura).id }
    end

    assert_redirected_to status_path(assigns(:status))
    assert_equal assigns(:status).user_id, users(:paul).id
  end


  test "should be logged in to update a status" do
    post :update, id: @status, status: { content: @status.content }
    assert_response :redirect
    assert_redirected_to new_user_session_path
  end

  test "should get edit when logged in" do
    sign_in users(:paul)
    get :edit, id: @status
    assert_response :success
  end

  test "should update status when logged in" do
    sign_in users(:paul)
    put :update, id: @status, status: { content: @status.content }
    assert_redirected_to status_path(assigns(:status))
  end
  test "should create an activity for update status" do
    sign_in users(:paul)
    assert_difference('Activity.count') do
      put :update, id: @status, status: { content: @status.content }
    end
  end

  test "should update status for current user when logged in" do
    sign_in users(:paul)
    put :update, id: @status, status: { content: @status.content, user_id: users(:laura).id }
    assert_equal assigns(:status).user_id, users(:paul).id
  end

  test "should not update status if nothing has changed" do
    sign_in users(:paul)
    put :update, id: @status
    assert_redirected_to status_path(assigns(:status))
    assert_equal assigns(:status).user_id, users(:paul).id
  end

end
