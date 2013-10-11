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
        format.html  { redirect_to(@picture,
                      :notice => 'Picture was successfully updated.') }
        format.json  { head :no_content }
      else
        format.html  { render :action => "edit" }
        format.json  { render :json => @picture.errors,
                      :status => :unprocessable_entity }
      end
    end
  end

end
