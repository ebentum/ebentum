class EventsController < ApplicationController

  before_filter :authenticate_user!, :except => [:show, :index]
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

  def index

    #Eventos que se han unido la gente a la que yo sigo
    #@events = Event.joins(:appointments, :users => :followings).where(:users => { :id => current_user }).order("appointments.created_at DESC")

    #Eventos creados por gente a la que sigo
    #@events = Event.joins(:user => :followings).where(:users => { :id => current_user }).order("events.created_at DESC")

    #Eventos creados por mi
    #@events = Event.where(:user_id => current_user).order("events.created_at DESC")

    #Eventos a los que me he unido
    #@events = Event.joins(:appointments, :users).where(:users => { :id => current_user }).order("appointments.created_at DESC")

    #@events = Activity.joins(:event, :user => :followings).where(:users => { :id => User.first })
    #Activity.joins(:event, :user => :followings).where([:users =>{:id => User.first}] | [:events => {:user_id => User.first}])
    #Activity.joins(:event, :user => :followings).where{[users.id == User.first)] | [:events => (:user_id => User.first)]}
    #Activity.joins(:event, :user).where{(users.id == User.first) | (events.user_id == User.first)}
    #Activity.joins(:event, :user).where{users.id >> User.all}
    #@events = Activity.where{(action=='CREATE') | (action=='CREATE')}

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @events }
    end
  end

  def popular
    @events = Event.all

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @events }
    end
  end

  def show

    # tiene token de acceso valido de facebook?
    #@fb_access_token = Fbtoken.get_access_token(current_user.id)
    @fb_access_token = current_user.fbtoken ? current_user.fbtoken.token : nil
    
    # tiene token de acceso valido de twitter?
    #@tw_access_token = Twtoken.get_access_token(current_user.id)
    @tw_access_token = current_user.twtoken ? current_user.twtoken.token : nil

    @event = Event.find(params[:id])
    # if user_signed_in?
    #   @user_appointment_id = Appointment.user_appointment_id(params[:id], current_user.id)
    # end
    # @appointed = @event.appointments.count
    @event_users = @event.users.count

    js_callback :params => {:event_id => @event.id, :lat => @event.lat, :lng => @event.lng, :user_appointment_id => @user_appointment_id}

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @event }
    end
  end

  def new
    @event = Event.new

    respond_to do |format|
      format.html { render :layout => 'modal_window' }
      format.json { render :json => @event }
    end
  end

  def create
    @event = Event.new(params[:event])

    #@event = current_user.events{ Event.new(params[:event]) }

    @event.creator = current_user

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

end
