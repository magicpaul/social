class ApplicationController < ActionController::Base
  protect_from_forgery

  rescue_from ActiveRecord::RecordNotFound, with: :render_404



  def after_sign_out_path_for(users)
	sign_in_path
  end
  def create
	@user = User.create( params[:user] )
  end

  private
  def render_404
    render file: 'public/404', status: :not_found
  end
end
