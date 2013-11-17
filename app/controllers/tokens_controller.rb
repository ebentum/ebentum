class TokensController < ApplicationController

  skip_before_filter :auth_user
  skip_before_filter :verify_authenticity_token

  respond_to :json

  def create
    if params[:user_id].nil?
      email = params[:email]
      password = params[:password]
      logger.info(request)
      # if request.format != :json
      #   render :status=>406, :json=>{:message=>"The request must be json #{request.format}"}
      #   return
      # end

      if email.nil? or password.nil?
         render :status=>400,
                :json=>{:message=>"The request must contain the user email and password."}
         return
      end

      @user = User.find_by(:email => email.downcase)

      if @user.nil?
        logger.info("User #{email} failed signin, user cannot be found.")
        render :status=>401, :json=>{:message=>"Invalid email or password."}
        return
      end

      # http://rdoc.info/github/plataformatec/devise/master/Devise/Models/TokenAuthenticatable
      @user.ensure_authentication_token!

      if not @user.valid_password?(password)
        logger.info("User #{email} failed signin, password \"#{password}\" is invalid")
        render :status=>401, :json=>{:message=>"Invalid email or password."}
      else
        render :status=>200, :json=>{:token=>@user.authentication_token}
      end

    else
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
  end

  def get

    email = params[:email]
    password = params[:password]
    if request.format != :json
      render :status=>406, :json=>{:message=>"The request must be json"}
      return
    end

    if email.nil? or password.nil?
       render :status=>400,
              :json=>{:message=>"The request must contain the user email and password."}
       return
    end

    @user = User.find_by_email(email.downcase)

    if @user.nil?
      logger.info("User #{email} failed signin, user cannot be found.")
      render :status=>401, :json=>{:message=>"Invalid email or passoword."}
      return
    end

    # http://rdoc.info/github/plataformatec/devise/master/Devise/Models/TokenAuthenticatable
    @user.ensure_authentication_token!

    if not @user.valid_password?(password)
      logger.info("User #{email} failed signin, password \"#{password}\" is invalid")
      render :status=>401, :json=>{:message=>"Invalid email or password."}
    else
      render :status=>200, :json=>{:token=>@user.authentication_token}
    end
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
