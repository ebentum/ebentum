class AppointmentsController < ApplicationController

  respond_to :html, :json

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
