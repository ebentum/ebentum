class ApplicationController < ActionController::Base
  protect_from_forgery

  layout :layout_by_resource

  protected

  def layout_by_resource
    if devise_controller?
      "devise"
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

end
