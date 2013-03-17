class TokensController < ApplicationController

  def create
    user = User.find(params[:user_id])
    if params[:provider] == 'facebook'
      token = Fbtoken.new(params[:token])
      user.fbtoken = token
    elsif params[:provider] == 'twitter'
      token = Twtoken.new(params[:token])
      user.twtoken = token  
    end
    render :json => user.save
  end

  def update
    if params[:provider] == 'facebook'
      if current_user.fbtoken
        render :json => current_user.fbtoken.update_attributes(:autopublish => !current_user.fbtoken.autopublish)
      else
        render :json => true 
      end
    elsif params[:provider] == 'twitter'
      if current_user.twtoken
        render :json => current_user.twtoken.update_attributes(:autopublish => !current_user.twtoken.autopublish)  
      else
        render :json => true 
      end
    end
  end

  def destroy
    if params[:provider] == 'facebook'
      current_user.fbtoken = nil
    elsif params[:provider] == 'twitter'
      current_user.twtoken = nil  
    end
    render :json => true
  end

end
