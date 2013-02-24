class FbtokensController < ApplicationController

  def create
    fbtoken = Fbtoken.new(params[:fbtoken])
    fbtoken.autopublish = false
    if fbtoken.save
      render :json => fbtoken
    end
  end

  def update
    @fbtoken = Fbtoken.find_by_id(params[:id])
    if @fbtoken
      @fbtoken.autopublish = !@fbtoken.autopublish
      if @fbtoken.save
        render :json => true
      else
        render :json => @fbtoken.errors, :status => :unprocessable_entity
      end
    else
      render :json => true
    end
  end

  def destroy
    @fbtoken = Fbtoken.find(params[:id])
    if @fbtoken
      @fbtoken.destroy
    end
    render :json => true
  end

end
