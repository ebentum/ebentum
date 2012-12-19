class HomeController < ActionController::Base
  
  def index
    render js: "window.location.pathname='#{root_path}'"
  end
  
end
