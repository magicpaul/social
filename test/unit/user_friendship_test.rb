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
		assert users(:paul).pending_friends.include?(users(:rach))
	end
	context "a new instance" do
		setup do
			@userfriendship = UserFriendship.new user: users(:paul), friend: users(:rach)
		end
		should "have a pending state" do
			assert_equal 'pending', @userfriendship.state
		end
	end
	context "#send_request_email" do
		setup do
			@userfriendship = UserFriendship.create user: users(:paul), friend: users(:rach)
		end
		should "send an email" do
			assert_difference 'ActionMailer::Base.deliveries.size', 1 do
				@userfriendship.send_request_email
			end
		end
	end
	context "#accept!" do
		setup do
			@userfriendship = UserFriendship.create user: users(:paul), friend: users(:rach)
		end

		should "set the state to accepted" do
			@userfriendship.accept!
			assert_equal "accepted", @userfriendship.state
		end
		should "send an acceptance email" do
			assert_difference 'ActionMailer::Base.deliveries.size', 1 do
				@userfriendship.accept!
			end
		end
		should "include friend in friendlist" do
			@userfriendship.accept!
			users(:paul).friends.reload
			assert users(:paul).friends.include?(users(:rach))
		end
	end
	context ".request" do
		should "create two user frienships" do
			assert_difference 'UserFriendship.count', 2 do
				UserFriendship.request(users(:paul), users(:rach))
			end
		end
		should "send a friend request email" do
			assert_difference 'ActionMailer::Base.deliveries.size', 1 do
				UserFriendship.request(users(:paul), users(:rach))
			end
		end
	end
end
