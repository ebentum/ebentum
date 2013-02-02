class EventsController < ApplicationController

  before_filter :authenticate_user!, :except => [:show, :index]

  def index
    @events = Event.all

    #Eventos que se han apuntado la gente a la que yo sigo
    #@events = Event.joins(:appointments, :users => :followings).where(:users => { :id => current_user }).order("appointments.created_at DESC")

    #Eventos creados por gente a la que sigo
    #@events = Event.joins(:user => :followings).where(:users => { :id => current_user }).order("events.created_at DESC")

    #Eventos creados por mi
    #@events = Event.where(:user_id => current_user).order("events.created_at DESC")

    #Eventos a los que me he apuntado
    #@events = Event.joins(:appointments, :users).where(:users => { :id => current_user }).order("appointments.created_at DESC")

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
    @event = Event.find(params[:id])
    if user_signed_in?
      @user_appointment_id = Appointment.user_appointment_id(params[:id], current_user.id)
    end
    @appointed = @event.appointments.count

    js_callback :params => {:lat => @event.lat, :lng => @event.lng, :user_appointment_id => @user_appointment_id}

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

    @event.user_id = current_user.id

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
