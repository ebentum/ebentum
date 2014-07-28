class ApplicationController < ActionController::Base
  protect_from_forgery

  before_filter :set_locale, :auth_user, :check_mobile

  layout :layout_by_resource

  protected

  def set_locale
    @locale = extract_locale_from_accept_language_header
    I18n.locale = @locale || I18n.default_locale
  end

  def auth_user
    if !user_signed_in? && !devise_action && !isWelcomePage
      if isAllowedEndPointToCrawlers and isCrawler
        logger.info 'Allowing content to crawlers'
      else
        cookies.delete :ebentum_userid
        cookies.delete :ebentum_username
        redirect_to '/welcome'
      end
    else
      if current_user
        cookies.permanent[:ebentum_userid] = current_user.id
        cookies.permanent[:ebentum_username] = current_user.complete_name
      else
        cookies.delete :ebentum_userid
        cookies.delete :ebentum_username
      end
    end
  end

  def check_mobile
    if params[:native_app] || cookies[:ebentum_native] == 'true'
      @native_app = true
    else
      @native_app = false
    end

    @show_mobile_app_banner = false

    if request.user_agent.downcase.include?'android'
      @show_mobile_app_banner = true
    end
  end

  def isWelcomePage
    controller_name == 'welcome' and action_name == 'index'
  end

  def isAllowedEndPointToCrawlers
    controller_name == 'events' and action_name == 'search'
  end

  # http://snippets.aktagon.com/snippets/221-how-to-detect-traffic-from-the-most-common-search-spiders-with-ruby-
  def isCrawler
    #true
    request.user_agent.downcase.include?'googlebot'
  end

  def user_logged
    if user_signed_in?
      redirect_to '/'
    end
  end

  def devise_action
    devise_controller? && (controller_name == 'registrations' || controller_name == 'sessions') && (action_name == 'new' || action_name == 'create')
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
