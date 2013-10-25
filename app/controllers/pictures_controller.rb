class PicturesController < ApplicationController

  def create
    respond_to do |format|
      if @picture.save
        format.json  { render :json => @picture.to_json(:methods => [:avatar_url]),
                      :status => :created, :location => @picture }
      else
        format.json  { render :json => @picture.errors,
                      :status => :unprocessable_entity }
      end
    end
  end

  def edit
    
  end

  def update
    respond_to do |format|
      if @picture.update_attributes(params[:picture])
        format.json  { render :json => @picture.to_json(:methods => [:avatar_url]),
                      :status => :created, :location => @picture }
      else
        format.json  { render :json => @picture.errors,
                      :status => :unprocessable_entity }
      end
    end
  end

end
