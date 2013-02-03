class UsersController < ApplicationController

  before_filter :authenticate_user! # se van a poder ver perfiles de usuario sin estar dado de alta?, :except => [:show, :index]
  before_filter :search_users, :only => [:index]

  def search_users

    @users = User.all

    # if params[:follower_id]
    #   user = User.find( params[:follower_id])
    #   @users = user.followers
    # elsif params[:following_id]
    #   user = User.find( params[:follower_id])
    #   @users = user.followings
    # else
    #   @users = User.all
    # end
  end

  def index

    if params[:no_layout]
      render_layout = false
    else
      render_layout = true
    end

    respond_to do |format|
      format.html { render :layout => render_layout} # index.html.erb
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

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: user }
    end
  end

  def edit
    @user = User.find(params[:id])

    @social_fb = @user.social_fb

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
