class UsersController < ApplicationController

  before_filter :authenticate_user!, :except => [:show, :index]

  def index
    users = User.all
    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: users }
    end
  end

  def show
    id = params[:id]

    @user = User.find(id)

    if @user != current_user
      @am_i_following = current_user.followings.where(:following_id => @user.id).first
      if not @am_i_following
        @new_following = Following.new(:user_id => current_user.id, :following_id => @user.id )
      end
      @is_follower = @user.followings.where(:following_id => current_user.id).first rescue nil
    else
      @am_i_following = nil
      @is_follower = nil
    end

    @following = @user.followings
    @followers = nil
    @user_events = nil
    @user_appointments = nil

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: user }
    end
  end

  def edit
    @user = User.find(params[:id])
    if @user != current_user
      respond_to do |format|
        format.html  { render :action => "show" }
      end
    end
  end

  def update
    @user = User.find(params[:id])

    respond_to do |format|
      if @user.update_attributes(params[:user])
        format.html  { redirect_to(@user,
                      :notice => 'User was successfully updated.') }
        format.json  { head :no_content }
      else
        format.html  { render :action => "edit" }
        format.json  { render :json => @user.errors,
                      :status => :unprocessable_entity }
      end
    end
  end

end
