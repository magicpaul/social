require 'test_helper'

class UserFriendshipsControllerTest < ActionController::TestCase
  context "#index" do
    context "when not logged in" do
      should "redirect to the login page" do
        get :index
        assert_response :redirect
      end
    end
    context "when logged in" do
      setup do
        @friendship1 = create(:pending_user_friendship, user: users(:paul), friend: create(:user, first_name:'Pending', last_name:'Friend'))
        @friendship2 = create(:accepted_user_friendship, user: users(:paul), friend: create(:user, first_name:'Accepted', last_name:'Friend'))

        sign_in users(:paul)
        get :index
      end
      should "get the index page without error" do
        assert_response :success
      end
      should  "assign user friendships" do
        assert assigns(:user_friendships)
      end
      should "display friend's names" do
        assert_match /Pending/, response.body
        assert_match /Accepted/, response.body
      end
      should "display pending friends" do
        assert_select "#user_friendship_#{@friendship1.id}" do
          assert_match /Friendship is pending./,response.body
        end
      end
      should "display accepted friends" do
        assert_select "#user_friendship_#{@friendship2.id}" do
          assert_match /Friendship started/,response.body
        end
      end
    end
  end

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
  context "#create" do
    context "when not logged in" do
      should "redirect to the login page" do
        get :new
        assert_response :redirect
        assert_redirected_to sign_in_path
      end
    end
    context "when logged in" do
      setup do
        sign_in users(:paul)
      end
      context "with no friend id" do
        setup do
          post :create
        end

        should "post flash message" do
          assert !flash[:error].empty?
        end
      end
      context "with valid friend id" do
        setup do
          post :create, user_friendship:{friend_id: users(:rach)}
        end
        should "create friendship object" do
          assert assigns(:friend)
          assert_equal users(:rach), assigns(:friend)
        end
        should "create user friendship object" do
          assert assigns(:user_friendship)
          assert_equal users(:paul), assigns(:user_friendship).user
          assert_equal users(:rach), assigns(:user_friendship).friend
        end
        should "create a friendship" do
          assert users(:paul).pending_friends.include?(users(:rach))
        end
        should "redirect to profile path" do
          assert_redirected_to profile_path(users(:rach))
        end
        should "display a success flash" do
          assert flash[:success]
          assert_equal "You are now friends with #{users(:rach).full_name}", flash[:success]
        end
      end
    end
  end
end
