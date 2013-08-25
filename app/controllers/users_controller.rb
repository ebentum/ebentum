class UsersController < ApplicationController

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

  def update


    if params[:user][:password].blank? && params[:user][:password_confirmation].blank?
        params[:user].delete(:password)
        params[:user].delete(:password_confirmation)
    end

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

  def following
    @user = User.find(params[:id])
    @users = @user.all_followees
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
    @users = @user.all_followers
    respond_to do |format|
      if params[:no_layout]
        format.html { render 'index', :layout => false}
      else
        format.html { render 'index'}
      end
      format.json { render json: @users }
    end
  end

  def follow
    @user = User.find(params[:id])
    current_user.follow(@user)

    respond_to do |format|
      format.html { redirect_to @user }
      format.js
    end
  end

  def unfollow
    @user = User.find(params[:id])
    current_user.unfollow(@user)

    respond_to do |format|
      format.html { redirect_to @user }
      format.js
    end

  end

  def created_events
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

  def events
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

  def edit_password
    @user  = User.find(current_user.id)
  end

  def update_password
    @user = User.find(current_user.id)
    if @user.update_with_password(params[:user])
      # Sign in the user by passing validation in case his password changed
      sign_in @user, :bypass => true
      redirect_to root_path
    else
      @error = true
      render 'edit_password', :layout => 'no_navbar'
    end
  end

  # def update_main_picture
  #   picture = Picture.find(params[:picture])
  #   current_user.main_picture = picture

  #   respond_to do |format|
  #     if picture.save
  #       format.json  { render :json => picture,
  #                     :status => :created, :location => picture }
  #     else
  #       format.json  { render :json => picture.errors,
  #                     :status => :unprocessable_entity }
  #     end
  #   end
  # end

end
