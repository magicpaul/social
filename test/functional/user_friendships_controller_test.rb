require 'test_helper'

class UserFriendshipsControllerTest < ActionController::TestCase
  context "#new" do
  	context "when not logged in" do
  		should "redirect to the login page" do
  			get :new
  			assert_response :redirect
  		end
  	end

  	context "when logged in" do
  		setup do
  			sign_in users(:paul)
  		end
  		should "get new and return success" do
  			get :new
  			assert_response :success
  		end
  		should "set an error if friend_id params is missing" do
  			get :new, {}
  			assert_equal "Friend required", flash[:error]
  		end

  		should "display the friend's name" do
  			get :new, friend_id: users(:laura)
  			assert_match /#{users(:laura).full_name}/, response.body
  		end

  		should "assign a new user friendship" do
  			get:new, friend_id: users(:laura)
  			assert_equal users(:laura), assigns(:user_friendship).friend
  		end

  		should "assign a new user friendship to currently logged in user" do
  			get:new, friend_id: users(:laura)
  			assert_equal users(:paul), assigns(:user_friendship).user
  		end

  		should "return a 404 if friend not found" do
  			get :new, friend_id: "yo momma"
  			assert_response :not_found
  		end

  		should "ask if you really want to go through with this." do
  			get :new, friend_id: users(:laura)
  			assert_match /Do you really want to friend #{users(:laura).full_name}?/, response.body
  		end
  	end
  end
end
