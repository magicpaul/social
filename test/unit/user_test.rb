require 'test_helper'

class UserTest < ActiveSupport::TestCase
  should have_many(:user_friendships)
  should have_many(:friends)
  should have_many(:pending_user_friendships)
  should have_many(:pending_friends)
  should have_many(:requested_user_friendships)
  should have_many(:requested_friends)
  should have_many(:blocked_user_friendships)
  should have_many(:blocked_friends)
  should have_many(:activities)

  test "a user should enter a first name" do
  	user = User.new
  	assert !user.save
  	assert !user.errors[:first_name].empty?
  end

  test "a user should enter a last name" do
  	user = User.new
  	assert !user.save
  	assert !user.errors[:last_name].empty?
  end
  test "user should have a profile name" do
    user = User.new
    assert !user.save
    assert !user.errors[:profile_name].empty?
  end
  test "user should have a profile name without spaces" do
    user = User.new(first_name: 'Paul', last_name: 'Grant', email:'itspaulgrant1@gmail.com')
    user.password = user.password_confirmation = "password"
    user.profile_name = "Paul Grant"
    assert !user.save
    assert user.errors[:profile_name].include?("Must be formatted correctly")
  end
  test "user should have a correctly formatted profile name" do
    user = User.new(first_name: 'Paul', last_name: 'Grant', email:'test@test.com')
    user.password = user.password_confirmation = "password123"
    user.profile_name = "paulgrant_1"
    assert user.valid?
  end
  test "no errors raised when accessing friends" do
    assert_nothing_raised do
      users(:paul).friends
    end
  end

  test "that creating friendships works" do
    users(:paul).friends << users(:rach)
    users(:paul).friends.reload
    assert users(:paul).pending_friends.include?(users(:rach))
  end

  test "that calling to_param displays profile name" do
    assert_equal "paulgrant1", users(:paul).to_param
  end

  context "#has_blocked?" do

    should "return true if a user has blocked another user" do
      assert users(:paul).has_blocked?(users(:blocked_friend))
    end

    should "return false if a user has not blocked another user" do
      assert !users(:paul).has_blocked?(users(:laura))
    end

  end

  context "#create_activity" do
    should "increase the activity count" do
      assert_difference 'Activity.count' do
        users(:paul).create_activity(statuses(:one),'created')
      end
    end

    should "set the targetable instance to the item passed in" do
      activity = users(:paul).create_activity(statuses(:one),'created')
      assert_equal statuses(:one), activity.targetable
    end
  end

end
