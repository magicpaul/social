require 'test_helper'

class UserTest < ActiveSupport::TestCase
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
end
