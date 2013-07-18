class WelcomeController < ApplicationController

  skip_before_filter :auth_user

  def index
  end

end
