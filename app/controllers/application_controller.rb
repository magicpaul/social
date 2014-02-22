class ApplicationController < ActionController::Base
  protect_from_forgery
  def after_sign_out_path_for(users)
	sign_in_path 
  end
  def create
	@user = User.create( params[:user] )
  end
end
