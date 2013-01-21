class AppointmentsController < ApplicationController

  respond_to :html, :json
  
  # def index
  #   users = User.all
  #   respond_to do |format|
  #     format.html # index.html.erb
  #     format.json { render json: users }
  #   end
  # end

  # def show
  #   user = User.find(params[:id])
  #   render json: user
  # end

  def create
    appointment          = Appointment.new()
    appointment.event_id = params[:event_id]
    appointment.user_id  = current_user.id

    if appointment.save
      render :json => appointment
    else
      render :json => false
    end
  end

  def destroy
    appointment = Appointment.find(params[:id])
    appointment.destroy

    head :no_content 
  end

end
