class ActivitiesController < ApplicationController

  def index
    @last_activity_date = params[:last_activity_date]
    @activities = ActivityStream.user_activity_stream(current_user, @last_activity_date)

    if request.xhr?
      js_callback false
    end

    @show_fb_friends = params[:show_fb_friends]

    @fb_friends = get_token_friends_with_ebentum(current_user)

    respond_to do |format|
      if request.xhr?
        format.html { render :layout => nil}
      else
        format.html { render :layout => 'fullwidth' }
      end
      format.json { render json: @activities }
    end
  end

  # TODO: Refactor, en el modelo fbtoken tenemos el mismo código.
  def get_token_friends_with_ebentum(current_user)

    if current_user.fbtoken?
      # instanciamos el objeto fb
      fb = Koala::Facebook::API.new(current_user.fbtoken.token)
      # uids de fb de nuestros amigos de fb que tienen ebentum
      fb_uids = fb.get_connections("me", "friends", :fields => "id, installed") # amigos de fb. obtenemos id e installed (ebentum)
                .select {|user| user.key?('installed')} # nos quedamos con los que tienen ebentum instalado
                .map {|installed| installed['id']} # de los que tienen ebentum instalado nos quedamos con la id de fb
      # obtenemos los usuarios de ebentum que tienen esas uids en el token de fb
      User.where('fbtoken.uid' => fb_uids)
    else
      nil
    end
    # DEV
    #User.all
  end

end
