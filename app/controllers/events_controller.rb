class EventsController < ApplicationController

  skip_before_filter :auth_user, :only => [:show]
  before_filter :search_events, :only => [:index]

  def search_events
    if params[:user_id]
      @user = User.find(params[:user_id])
    end

    if @user
      if params[:appointments]
        @events = @user.events
      else
        @events = @user.created_events
      end
    end

  end

  def event_search

  end

  def search

    @page = params[:page] || 1

    user = current_user

    my_location = [user.coordinates[1], user.coordinates[0]]

    @distanceSelected = params[:distance] || 2 # Cerca
    @daysSelected     = params[:days]     || 2 # Pronto
    @events           = Event
    if @distanceSelected.to_i > 0
      @events = @events.near(my_location, @distanceSelected, :units => :km)
    end
    if @daysSelected.to_i > 0
      @events = @events.where(:start_date.gte => Date.today, :start_date.lte => @daysSelected.to_i.days.from_now)
    end

    @events = @events.order_by("appointments_count desc")
    @events = @events.page(@page)

    if request.xhr?
      js_callback false
    end

    respond_to do |format|
      if request.xhr?
        format.html { render :layout => nil}
      else
        format.html { render :layout => 'fullwidth' }
      end
      format.json { render json: @events }
    end
  end

  def index
    @page = params[:page] || 1

    @events = @events.order_by("start_date desc")
    @events = @events.page(@page)

    if request.xhr?
      js_callback false
    end

    respond_to do |format|
      if request.xhr?
        format.html { render :layout => nil}
      else
        format.html { render :layout => 'fullwidth' }
      end
      format.json { render json: @events }
    end
  end


  def show

    # tiene token de acceso validos?
    if current_user
      @fb_access_token = current_user.fbtoken || nil
      @tw_access_token = current_user.twtoken || nil
    end

    @event = Event.find(params[:id])
    if user_signed_in?
      @joined = @event.users.find(current_user) != nil
      # en caso de => raise_not_found_error: true
      # begin
      #   @joined = @event.users.find(current_user) != nil
      # rescue Mongoid::Errors::DocumentNotFound
      #   @joined = false
      # end
    end
    @event_users = @event.users.size

    # Temas de mejora de SEO
    @head_title       = @event.name
    @meta_description = @event.description+' '+t(:meta_description, :event_name => @event.name, :joined => @event_users)
    @meta_keywords    = @event.description

    js_callback :params => {:event_id => @event.id, :lat => @event.lat, :lng => @event.lng, :joined => @joined}

    # open graph
    @og_title       = @event.name
    @og_type        = 'website'
    @og_description = @meta_description
    @og_url         = 'http://www.ebentum.com'+event_path(@event)
    @og_image       = @event.get_picture.photo.url(:medium)

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @event }
    end
  end


  def new
    @event = Event.new
    @picture = EventPicture.new

    respond_to do |format|
      format.html { render :layout => 'modal_window' }
      format.json { render :json => @event }
    end
  end

  def create
    @event = Event.new(params[:event])
    # Meter 'lat' y 'lng' en array 'coordinates'
    @event.coordinates = [params[:event][:lng].to_f, params[:event][:lat].to_f] # to_f para pasarlos a float
    @event.creator = current_user

    picture = EventPicture.find(params[:event][:main_picture_id])
    if picture
      @event.main_picture = picture
      picture.save
    #else
    #  picture = Picture.new
    #  @event.main_picture = picture
    end


    respond_to do |format|
      if @event.save
        format.html  { redirect_to(@event,
                      :notice => 'Event was successfully created.') }
        format.json  { render :json => @event,
                      :status => :created, :location => @event }
      else
        format.html  { render :action => "new" }
        format.json  { render :json => @event.errors,
                      :status => :unprocessable_entity }
      end
    end
  end

  def edit
    @event = Event.find(params[:id])
    @picture = @event.get_picture

    respond_to do |format|
      format.html { render :layout => 'modal_window' }
      format.json { render :json => @event }
    end
  end

  def update
    logger.info "----------------------------0"

    @event = Event.find(params[:id])

    logger.info "----------------------------1"

    if @event.creator != current_user
      render :json => false
    else
      picture = Picture.find(params[:event][:main_picture_id])
      if params[:event][:main_picture_id] != '#'
        if picture.nil?
          @event.main_picture = nil
        else
          @event.main_picture = picture
        end
      end

    logger.info "----------------------------2"

      respond_to do |format|
        if @event.update_attributes(params[:event])
          format.html  { redirect_to(@event,
                        :notice => 'Event was successfully updated.') }
          format.json  { head :no_content }
        else
          format.html  { render :action => "edit" }
          format.json  { render :json => @event.errors,
                        :status => :unprocessable_entity }
        end
      end
    end
  end

  def destroy
    @event = Event.find(params[:id])

    if @event.creator != current_user
      render :json => false
    else
      @event.destroy

      respond_to do |format|
        format.html { redirect_to events_url }
        format.json { head :no_content }
      end
    end
  end

  def add_user
    event_id = params[:eventid]
    event    = Event.find(event_id)
    event.users.push(current_user)
    event.appointments_count = event.appointments_count + 1

    Activity.new.fill_data("join", current_user, event).save

    render :json => event.save
  end

  def remove_user
    event_id = params[:eventid]
    event    = Event.find(event_id)
    user     = current_user
    event.users.delete(user)
    event.appointments_count = event.appointments_count - 1

    activity = Activity.where("verb" => "join", "actor._id" => user._id, "subject._id" => event._id)
    activity.delete_all

    render :json => event.save
  end

end
