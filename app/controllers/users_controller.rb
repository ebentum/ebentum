class UsersController < ApplicationController

  before_filter :search_users, :only => [:index]

  def search_users
    if params[:event_id]
      @event = Event.find(params[:event_id])

      if @event
        @users = @event.users
        @page = params[:page] || '1'
      end
    end

  end

  def index


    @users = @users.page(@page)

    if request.xhr?
      js_callback false
    end

    respond_to do |format|
      if request.xhr?
        format.html { render 'index', :layout => nil}
      else
        format.html { render 'index', :layout => 'fullwidth' }
      end
      format.json { render json: @users }
    end



  end
  def show
    id = params[:id]

    @user = User.find(id)

    respond_to do |format|
      format.html { render :layout => 'fullwidth'}
      format.json { render json: user }
    end
  end

  def update
    if params[:user][:password].blank? && params[:user][:password_confirmation].blank?
        params[:user].delete(:password)
        params[:user].delete(:password_confirmation)
    end

    @user = User.find(params[:id])

    if @user != current_user
      render :json => false
    else
      picture = Picture.find(params[:user][:main_picture_id])
      if params[:user][:main_picture_id] != '#'
        if picture.nil?
          @user.main_picture = nil
        else
          @user.main_picture = picture
        end
      end

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

  def following

    @page = params[:page] || '1'

    @user = User.find(params[:id])
    @users = @user.all_followees


    if request.xhr?
      js_callback false
    end

    respond_to do |format|
      if request.xhr?
        format.html { render 'index', :layout => nil}
      else
        format.html { render 'index', :layout => 'fullwidth' }
      end
      format.json { render json: @users }
    end
  end

  def followers

    @page = params[:page] || '1'

    @user = User.find(params[:id])
    @users = @user.all_followers

    if request.xhr?
      js_callback false
    end

    respond_to do |format|
      if request.xhr?
        format.html { render 'index', :layout => nil}
      else
        format.html { render 'index', :layout => 'fullwidth' }
      end
      format.json { render json: @users }
    end
  end

  def follow
    @user = User.find(params[:id])
    current_user.follow(@user)
    @user = User.find(params[:id])
    receivers = current_user.all_followers.map {|user| user.id}

    Activity.new(
      :verb => "follow",
      :actor_id => current_user.id,
      :object_type => "User",
      :object_id => @user.id,
      :receivers => receivers,
      :date => Time.now
    ).save

    respond_to do |format|
      format.html { redirect_to @user }
      format.json { render json: @user }
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

  def edit_password
    @user  = User.find(current_user.id)
  end

  def update_password
    @user = User.find(current_user.id)
    if (params[:user][:password] == "" || params[:user][:password_confirmation] == "")
      @error = true
      render 'edit_password', :layout => 'no_navbar'
    elsif @user.update_with_password(params[:user])
      # Sign in the user by passing validation in case his password changed
      sign_in @user, :bypass => true
      redirect_to root_path
    else
      @error = true
      render 'edit_password', :layout => 'no_navbar'
    end
  end


  def update_position
    user = User.find(current_user.id)
    user.lat = params[:lat]
    user.lng = params[:lng]
    user.setCoordinates
    render json: user
  end

  def search
    @q = params[:q]

    if !@q.nil?
      @users = User.search(@q)
    end

    respond_to do |format|
      if request.xhr?
        format.html { render :layout => nil}
      else
        format.html { render :layout => 'fullwidth' }
      end
      format.json { render json: @users }
    end

  end

end
