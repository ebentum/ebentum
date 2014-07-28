class WelcomeController < ApplicationController

  skip_before_filter :auth_user
  before_filter :user_logged, :only => [:index]

  def index
    # para activar el contenido 'especial' para los crawlers
    if isCrawler
      @isCrawler = true
    end
  end

  def sign_up_ok
    @sign_up_email = params[:email]
  end

end
