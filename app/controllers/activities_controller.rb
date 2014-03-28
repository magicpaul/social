class ActivitiesController < ApplicationController
  def index
    @unreadActivities = []
    @activities = Activity.for_user(current_user, params)
    @activities.each do |activity|
        @unreadActivities << activity if current_user.has_unread?(activity)
    end
    respond_to do |format|
      format.html # index.html.erb
      format.json {
        render json: @unreadActivities
      }
    end
  end
  def read
    @activity = Activity.find(params[:id])
    @activity.mark_read(current_user)
    respond_to do |format|
        format.html{
            redirect_to activities_path
        }
        format.js
    end
  end
  def all_read
    @activity = Activity.find(params[:id])
    @activity.mark_read(current_user)
    redirect_to activities_path
  end
end