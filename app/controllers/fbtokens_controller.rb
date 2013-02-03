class FbtokensController < ApplicationController

  def create
    fbtoken = Fbtoken.new(params[:fbtoken])
    fbtoken.user_id = current_user.id
    if fbtoken.save
      render :json => fbtoken
    else
      render :json => fbtoken.errors, :status => :unprocessable_entity
    end
  end

  def destroy
    @fbtoken = Fbtoken.find(params[:id])
    @fbtoken.destroy

    render :json => true
  end

end
