class TwtokensController < ApplicationController

  def destroy
    @twtoken = Twtoken.find(params[:id])
    @twtoken.destroy

    render :json => true
  end

end
