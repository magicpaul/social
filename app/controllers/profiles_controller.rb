class ProfilesController < ApplicationController
    def show
      	@user = User.find_by_profile_name(params[:id])
        @user_friendships = @user.user_friendships.all
      	if @user
      		@statuses = @user.statuses.all(:order => 'updated_at DESC')
      		render action: :show
      	else
      		render file: 'public/404', status: 404, formats: [:html]
        end
    end
end
