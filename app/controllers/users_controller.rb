class UsersController < ApplicationController

  def index
    users = User.all
    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: users }
    end
  end

  def show
    id = params[:id] || 1 # aqui falta tomar la id o el username del usuario conectado
    @user = User.find(id)
    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: user }
    end
  end

end
