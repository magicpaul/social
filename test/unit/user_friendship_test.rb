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
	context "#mutual_friendship" do
		setup do
			UserFriendship.request users(:paul), users(:rach)
			@friendship1 = users(:paul).user_friendships.where(friend_id: users(:rach).id).first
			@friendship2 = users(:rach).user_friendships.where(friend_id: users(:paul).id).first

		end
		should "correctly find the mutual friendship" do
			assert_equal @friendship2, @friendship1.mutual_friendship
		end
	end
	context "#accept_mutual_friendship!" do
		setup do
			UserFriendship.request users(:paul), users(:rach)
		end
		should "accept the mutual friendship" do			
			friendship1 = users(:paul).user_friendships.where(friend_id: users(:rach).id).first
			friendship2 = users(:rach).user_friendships.where(friend_id: users(:paul).id).first

			friendship1.accept_mutual_friendship!
			friendship2.reload

			assert_equal 'accepted', friendship2.state
		end
	end

	context "#accept!" do
		setup do
			@userfriendship = UserFriendship.request users(:paul), users(:rach)
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
		should "accept the mutual friendship" do
			@userfriendship.accept_mutual_friendship!
			assert_equal 'accepted', @userfriendship.mutual_friendship.state
		end
	end
	context ".request" do
		should "create two user friendships" do
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
	context "#delete_mutual_friendship!" do
		setup do
			UserFriendship.request users(:paul), users(:rach)
			
			@friendship1 = users(:paul).user_friendships.where(friend_id: users(:rach).id).first
			@friendship2 = users(:rach).user_friendships.where(friend_id: users(:paul).id).first
		end
		should "delete the mutual friendship" do
			assert_equal @friendship2, @friendship1.mutual_friendship
			@friendship1.delete_mutual_friendship!
			assert !UserFriendship.exists?(@friendship2.id)
		end
	end
	context "on destroy" do
		setup do
			UserFriendship.request users(:paul), users(:rach)
			
			@friendship1 = users(:paul).user_friendships.where(friend_id: users(:rach).id).first
			@friendship2 = users(:rach).user_friendships.where(friend_id: users(:paul).id).first
		end
		should "destroy mutual friendship" do
			@friendship1.destroy
			assert !UserFriendship.exists?(@friendship2.id)
		end
	end
	context "#block!" do
		setup do
			@userfriendship = UserFriendship.request users(:paul), users(:rach)

		end
		should "set the state to blocked" do
			@userfriendship.block!
			assert_equal "blocked", @userfriendship.state
			assert_equal "blocked", @userfriendship.mutual_friendship.state
		end
		should "not allow new user friendships after block" do
			@userfriendship.block!
			uf = UserFriendship.request users(:paul), users(:rach)
			assert !uf.save
		end
	end
end
