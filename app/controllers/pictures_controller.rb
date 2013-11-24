class PicturesController < ApplicationController

  def create
    @picture.creator = current_user

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
    if @picture.creator != current_user
      render :json => false
    else
      respond_to do |format|
        if @picture.update_attributes(@new_picture_params)
          format.json  { render :json => @picture.to_json(:methods => [:avatar_url]),
                        :status => :created, :location => @picture }
        else
          format.json  { render :json => @picture.errors,
                        :status => :unprocessable_entity }
        end
      end
    end
  end

end
