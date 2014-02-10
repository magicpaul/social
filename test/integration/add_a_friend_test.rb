require 'test_helper'

class AddAFriendTest < ActionDispatch::IntegrationTest
	def sign_in_as(user, password)
		post sign_in_path, user: { email: user.email, password: password }
	end
	test "that adding friends works" do
		sign_in_as users(:paul), "testing"

		get "/user_friendships/new?friend_id=#{users(:laura).profile_name}"
		assert_response :success

		assert_difference 'UserFriendship.count' do
			post "/user_friendships",user_friendship: {friend_id: users(:laura).profile_name}
			assert_response :redirect
			assert_equal "You are now friends with #{users(:laura).full_name}", flash[:success]
		end
	end
end
