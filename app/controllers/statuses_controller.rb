class StatusesController < ApplicationController
  before_filter :authenticate_user!, only: [:index, :new, :create, :edit, :update]

  # GET /statuses
  # GET /statuses.json
  def index
    @status = Status.new
    @statuses = Status.paginate(:per_page => 9, :page => params[:page]).order('updated_at DESC')
    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @statuses }
      format.js
    end
  end

  # GET /statuses/1
  # GET /statuses/1.json
  def show
    @status = Status.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @status }
    end
  end

  # GET /statuses/new
  # GET /statuses/new.json
  def new
    @status = Status.new

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @status }
    end
  end

  # GET /statuses/1/edit
  def edit
    @status = current_user.statuses.find(params[:id])
  end

  # POST /statuses
  # POST /statuses.json
  def create
    @status = current_user.statuses.new(params[:status])
    respond_to do |format|
      if @status.save
        current_user.create_activity(@status, 'created')
        current_user.add_points(5, category: 'Social')
        format.html { redirect_to statuses_url, notice: 'Status was successfully created.' }
        format.json { render json: @status, status: :created, location: @status }
        format.js
      else
        flash.now[:notice] = "Houston, we have a problem."
        format.html { render action: "new" }
        format.json { render json: @status.errors, status: :unprocessable_entity }
        format.js   { render "form_errors.js.erb" }
      end
    end
  end

  # PUT /statuses/1
  # PUT /statuses/1.json
  def update
    @status = current_user.statuses.find(params[:id])
    if params[:status] && params[:status].has_key?(:user_id)
      params[:status].delete(:user_id)
    end
    respond_to do |format|
      if @status.update_attributes(params[:status])
        current_user.create_activity(@status, 'updated')
        format.html { redirect_to statuses_url, notice: 'Status was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: "edit" }
        format.json { render json: @status.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /statuses/1
  # DELETE /statuses/1.json
  def destroy
    @status = current_user.statuses.find(params[:id])
    @status.destroy

    respond_to do |format|
      format.html { redirect_to statuses_url }
      format.json { head :no_content }
      format.js
    end
  end

  def like
    @status = Status.find(params[:id])
    current_user.upvotes @status
    current_user.create_activity(@status, 'liked')
    current_user.add_points(2, category: 'Social')
    if current_user != @status.user
      @status.user.add_points(2, category: 'Social')
    end
    respond_to do |format|
      format.html { redirect_to root_path }
      format.js
    end
  end

  def unlike
    @status = Status.find(params[:id])
    current_user.downvotes @status
    current_user.subtract_points(2, category: 'Social')
    if current_user != @status.user
      @status.user.subtract_points(2, category: 'Social')
    end
    respond_to do |format|
      format.html { redirect_to root_path }
      format.js
    end
  end
end