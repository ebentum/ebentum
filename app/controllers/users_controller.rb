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
    @events = @user.created_events
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
    @events = @user.events
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
