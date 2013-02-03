class FbtokensController < ApplicationController

  def destroy
    @fbtoken = Fbtoken.find(params[:id])
    @fbtoken.destroy

    render :json => true
  end

end
