class UsersController < ApplicationController

  before_filter :authenticate_user!, :except => [:save_token] # se van a poder ver perfiles de usuario sin estar dado de alta?
  before_filter :search_users, :only => [:index]

  def search_users

    # @users = User.all

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

  def save_token
    render :json => User.find(params[:user_id]).save_token(params[:provider], params[:token])
  end

end
