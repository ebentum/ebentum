class PicturesController < ApplicationController

  def create
    @picture = Picture.new(params[:picture])

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
    @picture = Picture.find(params[:id])
  end

  def update
    @picture = Picture.find(params[:id])

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

  def destroy
    @picture = Picture.find(params[:id])
    @picture.destroy
  end

end
