class TwtokensController < ApplicationController

  def create
    twtoken = Twtoken.new(params[:twtoken])
    twtoken.autopublish = false
    if twtoken.save
      render :json => twtoken
    end
  end

  def update
    @twtoken = Twtoken.find_by_id(params[:id])
    if @twtoken
      @twtoken.autopublish = !@twtoken.autopublish
      if @twtoken.save
        render :json => true
      else
        render :json => @twtoken.errors, :status => :unprocessable_entity
      end
    else
      render :json => true  
    end
  end

  def destroy
    @twtoken = Twtoken.find(params[:id])
    @twtoken.destroy

    render :json => true
  end

end
