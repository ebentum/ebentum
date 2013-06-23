class ApplicationController < ActionController::Base
  protect_from_forgery

  layout :layout_by_resource

  protected

  def auth_user
    render 'welcome/index', :layout => 'no_navbar' unless user_signed_in?
  end

  def layout_by_resource
    if devise_controller?
      if controller_name == 'registrations' && (action_name == 'new' || action_name == 'create')
        "no_navbar"
      elsif controller_name == 'sessions' && action_name == 'new'
        "no_navbar"
      else
        "application"
      end
    elsif controller_name == 'welcome'
      'no_navbar'
    else
      "application"
    end
  end

  def omniauth_provider
    flash[:omniauth_data].provider
  end

  def omniauth_uid
    flash[:omniauth_data].uid
  end

  def omniauth_email
    flash[:omniauth_data].info.email  
  end

  def omniauth_token
    flash[:omniauth_data].credentials.token  
  end

  def omniauth_token_expires_at
    flash[:omniauth_data].credentials.expires_at  
  end

  def omniauth_secret
    flash[:omniauth_data].credentials.secret  
  end

end
