class WelcomeController < ApplicationController

  skip_before_filter :auth_user
  before_filter :user_logged, :only => [:index]

  def index
    # para activar el contenido 'especial' para los crawlers
    if isCrawler
      @isCrawler = true
    end
    set_locale
  end

  def set_locale
    locale = extract_locale_from_accept_language_header
    I18n.locale = locale || I18n.default_locale
  end

  def extract_locale_from_accept_language_header
    if request.env['HTTP_ACCEPT_LANGUAGE'] == nil
      'es' # TODO: Para arreglar el error 500 del scraper. Hay que definir default.
    else
      request.env['HTTP_ACCEPT_LANGUAGE'].scan(/^[a-z]{2}/).first
    end
  end

  def sign_up_ok
    @sign_up_email = params[:email]
  end

end
