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
        @friendship3 = create(:requested_user_friendship, user: users(:paul), friend: create(:user, first_name:'Requested', last_name:'Friend'))
        @friendship4 = user_friendships(:blocked_by_paul)
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
      context "accepted users" do
        setup do
          get :index, list: 'accepted'
        end
        should "get the index sans error" do
          assert_response :success
        end
        should "not display pending, blocked or requested friends names" do
          assert_no_match /Pending\ Friend/, response.body
          assert_no_match /Blocked\ Friend/, response.body
          assert_no_match /Requested\ Friend/, response.body
        end
        should "display accepted friends names" do
          assert_match /Accepted\ Friend/, response.body
        end 
      end
      context "requested users" do
        setup do
          get :index, list: 'requested'
        end
        should "get the index sans error" do
          assert_response :success
        end
        should "not display pending, accepted or blocked friends names" do
          assert_no_match /Pending\ Friend/, response.body
          assert_no_match /Blocked\ Friend/, response.body
          assert_no_match /Accepted\ Friend/, response.body
        end
        should "display requested friends names" do
          assert_match /Requested\ Friend/, response.body
        end 
      end
      context "blocked users" do
        setup do
          get :index, list: 'blocked'
        end
        should "get the index sans error" do
          assert_response :success
        end
        should "not display pending, requested or accepted friends names" do
          assert_no_match /Pending\ Friend/, response.body
          assert_no_match /Requested\ Friend/, response.body
          assert_no_match /Accepted\ Friend/, response.body
        end
        should "display blocked friends names" do
          assert_match /Blocked\ Friend/, response.body
        end 
      end
      context "pending users" do
        setup do
          get :index, list: 'pending'
        end
        should "get the index sans error" do
          assert_response :success
        end
        should "not display accepted, blocked or requested friends names" do
          assert_no_match /Blocked\ Friend/, response.body
          assert_no_match /Accepted\ Friend/, response.body
          assert_no_match /Requested\ Friend/, response.body
        end
        should "display pending friends names" do
          assert_match /Pending\ Friend/, response.body
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

      context "successfully" do
        should "create two user friendship objects" do
          assert_difference 'UserFriendship.count', 2 do
            post :create, user_friendship: {friend_id: users(:rach).profile_name}
          end
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
          assert_equal "Friend request sent.", flash[:success]
        end
      end
    end
  end

  context "#accept" do
    context "when not logged in" do
      should "redirect to the login page" do
        put :accept, id: 1
        assert_response :redirect
        assert_redirected_to sign_in_path
      end
    end
    context "when logged in" do
      setup do
        @friend = create(:user)
        @user_friendship = create(:pending_user_friendship, user: users(:paul), friend: @friend)
        create(:pending_user_friendship, friend: users(:paul), user: @friend)
        sign_in users(:paul)
        put :accept, id: @user_friendship
        @user_friendship.reload
      end
      should "assign a user friendship" do
        assert assigns(:user_friendship)
        assert_equal @user_friendship, assigns(:user_friendship)
      end
      should "update user friendship state" do
        assert_equal 'accepted', @user_friendship.state
      end
      should "show flash success message" do
        assert_equal "You are now friends with #{@user_friendship.friend.first_name}", flash[:success]
      end
    end
  end
   context "#edit" do
    context "when not logged in" do
      should "redirect to the login page" do
        get :edit, id:1
        assert_response :redirect
      end
    end

    context "when logged in" do
      setup do
        @friend = create(:user)
        @user_friendship = create(:pending_user_friendship, user: users(:paul), friend: @friend)
        create(:pending_user_friendship, user: @friend, friend: users(:paul))
        sign_in users(:paul)
        get :edit, id: @user_friendship.friend.profile_name
      end
      should "get edit and return success" do
        assert_response :success
      end
      should "assign to user_friendship" do
        assert assigns(:user_friendship)
      end
      should "assign friend" do
        assert assigns(:friend)
      end
    end
  end
  context "#destroy" do
    context "when not logged in" do
      should "redirect to the login page" do
        delete :destroy, id: 1
        assert_response :redirect
        assert_redirected_to sign_in_path
      end
    end
    context "when logged in" do
      setup do
        @friend = create(:user)
        @user_friendship = create(:accepted_user_friendship, friend: @friend, user: users(:paul))
        create(:accepted_user_friendship, friend: users(:paul), user: @friend)
        sign_in users(:paul)
      end
      should "delete the user friendships" do
        assert_difference 'UserFriendship.count', -2 do
          delete :destroy, id: @user_friendship
        end
      end
      should "set the flash" do
        delete :destroy, id: @user_friendship
        assert_equal 'You are no longer friends',flash[:error]
      end
    end
  end
  context "#block" do
    context "when not logged in" do
      should "redirect to the login page" do
        put :block, id: 1
        assert_response :redirect
        assert_redirected_to sign_in_path
      end
    end
    context "when logged in" do
      setup do
        @user_friendship = create(:pending_user_friendship, user: users(:paul))
        sign_in users(:paul)
        put :block, id: @user_friendship
        @user_friendship.reload
      end
      should "assign a user_friendship object" do
        assert assigns(:user_friendship)
        assert_equal @user_friendship, assigns(:user_friendship)
      end

      should "update state to blocked" do
        assert_equal 'blocked', @user_friendship.state
      end
    end
  end
end
