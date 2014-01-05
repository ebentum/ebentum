class ApplicationController < ActionController::Base
  protect_from_forgery

  before_filter :auth_user, :get_locale

  layout :layout_by_resource

  protected

  def get_locale
    @locale = extract_locale_from_accept_language_header
  end

  def auth_user
    if !user_signed_in? && !devise_registration_action
      redirect_to '/welcome'
    end
  end

  def user_logged
    if user_signed_in?
      redirect_to '/'
    end
  end

  def devise_registration_action
    devise_controller? && controller_name == 'registrations' && (action_name == 'new' || action_name == 'create')
  end

  def layout_by_resource
    if devise_controller?
      if controller_name == 'registrations' && (action_name == 'new' || action_name == 'create')
        "no_navbar"
      elsif controller_name == 'sessions' && action_name == 'new'
        "no_navbar"
      elsif controller_name == 'passwords'
        "no_navbar"
      elsif controller_name == 'confirmations'
        "no_navbar"
      else
        "application"
      end
    elsif controller_name == 'welcome' || (controller_name == 'users' && action_name == 'edit_password')
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

  private

  def extract_locale_from_accept_language_header
    if request.env['HTTP_ACCEPT_LANGUAGE'] == nil
      'es' # TODO: Para arreglar el error 500 del scraper. Hay que definir default.
    else
      request.env['HTTP_ACCEPT_LANGUAGE'].scan(/^[a-z]{2}/).first
    end
  end

end
