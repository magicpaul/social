require 'test_helper'

class CustomRoutesTest < ActionDispatch::IntegrationTest
  test "sign_in route opens sign in page" do
  	get '/sign_in'
  	assert_response :success
  end
  test "register route opens sign up page" do
  	get '/register'
  	assert_response :success
  end
  test "view profile" do
  	get '/paulgrant1'
  	assert_response :success
  end
end
