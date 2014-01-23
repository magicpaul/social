require 'test_helper'

class UserFriendshipTest < ActiveSupport::TestCase
	should belong_to(:user)
	should belong_to(:friend)

	test "that creating a friendship works" do
		assert_nothing_raised do
			UserFriendship.create user: users(:paul), friend: users(:rach)
		end
	end

	test "tht creating a friendship based on IDs works" do
		UserFriendship.create user_id: users(:paul).id, friend_id: users(:rach).id
		assert users(:paul).friends.include?(users(:rach))
	end
end
