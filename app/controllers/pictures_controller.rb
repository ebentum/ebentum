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

end
