class UsersController < ApplicationController

  before_filter :authenticate_user! # se van a poder ver perfiles de usuario sin estar dado de alta?, :except => [:show, :index]
  before_filter :search_users, :only => [:index]

  def search_users

    if params[:follower_id]

      current_user = User.find( params[:follower_id])
      @users = current_user.followed_users

    elsif params[:followed_id]

      current_user = User.find( params[:followed_id])
      @users = current_user.followers

    else

      @users = User.all

    end

  end

  def index

    respond_to do |format|
      format.html
      format.json { render json: users }
    end
  end


  def show
    id = params[:id]

    @user = User.find(id)

    respond_to do |format|
      format.html
      format.json { render json: user }
    end
  end

  def following
    @user = User.find(params[:id])
    @users = @user.followed_users
    respond_to do |format|
      if params[:no_layout]
        format.html { render 'index', :layout => false}
      else
        format.html { render 'index'}
      end
      format.json { render json: @users }
    end
  end


  def edit
    @user = User.find(params[:id])

    # tiene token de acceso valido de facebook?
    @fb_access_token = Fbtoken.get_access_token(current_user.id)
    @fb_autopublish  = @fb_access_token.autopublish if @fb_access_token
    # tiene token de acceso valido de twitter?
    @tw_access_token = Twtoken.get_access_token(current_user.id)
    @tw_autopublish  = @tw_access_token.autopublish if @tw_access_token

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
  
  def followers
    @user = User.find(params[:id])
    @users = @user.followers
    respond_to do |format|
      if params[:no_layout]
        format.html { render 'index', :layout => false}
      else
        format.html { render 'index'}
      end
      format.json { render json: @users }
    end
  end

  def events
    @user = User.find(params[:id])
    @events = @user.events
    respond_to do |format|
      if params[:no_layout]
        format.html { render 'events/_list' , :layout => false}
      else
        format.html { render 'events/_list' }
      end
      format.json { render json: @events }
    end
  end

  def appointments
    @user = User.find(params[:id])
    @events = @user.joined_events
    respond_to do |format|
      if params[:no_layout]
        format.html { render 'events/_list' , :layout => false}
      else
        format.html { render 'events/_list'}
      end
      format.json { render json: @events }
    end
  end

end
