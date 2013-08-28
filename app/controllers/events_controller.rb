class EventsController < ApplicationController

  skip_before_filter :auth_user, :only => [:show]
  before_filter :search_events, :only => [:index]

  def search_events
    if params[:user_id]
      @user = User.find(params[:user_id])
    end

    if @user
      if params[:appointments]
        @events = @user.joined_events
      else
        @events = @user.events
      end
    else
      @events = Event.all
    end

  end

  def search
    my_location       = [43.28441, -2.172193] # Zarautz. Esto hay que obtenerlo de request.location
    @distanceSelected = params[:distance] || 2 # A 2 km
    @daysSelected     = params[:days]     || 1 # Hoy
    @events           = Event
    if @distanceSelected.to_i > 0
      @events = @events.near(my_location, @distanceSelected, :units => :km)
    end
    if @daysSelected.to_i > 0
      @events = @events.where(:start_date.gte => Date.today, :start_date.lte => @daysSelected.to_i.days.from_now)
    end

    @events = @events.order_by("start_date asc")

    respond_to do |format|
      # format.html # index.html.erb
      format.html { render :layout => 'fullwidth' }
      format.json { render json: @events }
    end
  end

  def index
    respond_to do |format|
      # format.html # index.html.erb
      format.html { render :layout => 'fullwidth' }
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

    js_callback :params => {:event_id => @event.id, :lat => @event.lat, :lng => @event.lng, :joined => @joined}

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @event }
    end
  end

  def new
    @event = Event.new
    @picture = Picture.new

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

    picture = Picture.find(params[:event][:main_picture_id])
    if picture
      @event.main_picture = picture
    else
      picture = Picture.new
      @event.main_picture = picture
    end
    picture.save

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
  end

  def update
    @event = Event.find(params[:id])

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

  def destroy
    @event = Event.find(params[:id])
    @event.destroy

    respond_to do |format|
      format.html { redirect_to events_url }
      format.json { head :no_content }
    end
  end

  def add_user
    event_id = params[:eventid]
    event    = Event.find(event_id)
    event.users.push(current_user)

    # Crear la actividad de apuntarse
    activity = Activity.new
    activity.verb = "join"

    activity.actor = Actor.new
    activity.actor.url = user_path(current_user)
    activity.actor.objectType = "user"
    activity.actor.displayName = current_user.complete_name
    activity.actor.photoUrl = current_user.image.url(:thumb)

    activity.subject = Subject.new
    activity.subject.objectType = "event"
    activity.subject.url = event_path(event)
    activity.subject.displayName = event.name
    activity.subject.photoUrl = event.main_picture.photo.url(:small)
    activity.subject.address = event.place
    activity.subject.startDate = event.start_date
    activity.subject.startTime = event.start_time

    activity.receivers = event.creator.all_followers
    activity.receivers.push(event.creator)

    activity.save
    # Fin de crear la actividad de apuntarse

    render :json => event.save
  end

  def remove_user
    event_id = params[:eventid]
    event    = Event.find(event_id)
    user     = current_user
    event.users.delete(user)
    render :json => event.save
  end

end
