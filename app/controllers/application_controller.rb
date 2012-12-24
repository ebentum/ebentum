class ApplicationController < ActionController::Base
  protect_from_forgery

  layout :layout_by_resource

  def store_omniauth_data(data)
    session["devise.omniauth_data"] = data
  end

  protected

  def layout_by_resource
    if devise_controller?
      "devise"
    else
      "application"
    end
  end

end
