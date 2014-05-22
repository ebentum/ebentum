class ActivitiesController < ApplicationController

  def index
    @last_activity_date = params[:last_activity_date]
    @activities = ActivityStream.user_activity_stream(current_user, @last_activity_date)

    if request.xhr?
      js_callback false
    end

    @show_fb_friends = params[:show_fb_friends]

    @fb_friends = get_token_friends_with_ebentum(current_user.fbtoken.token)

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
  # funcion que devuelve un array de ids de usuario de ebentum que son amigos nuestros en facebook
  def get_token_friends_with_ebentum(token)
    # array de ids de ususario de ebentum a los que hay que notificar
    friends = []
    # instanciamos el objeto fb
    fb = Koala::Facebook::API.new(token)
    # uids de fb de nuestros amigos de fb que tienen ebentum
    fb_uids = fb.get_connections("me", "friends", :fields => "id, installed") # amigos de fb. obtenemos id e installed (ebentum)
              .select {|user| user.key?('installed')} # nos quedamos con los que tienen ebentum instalado
              .map {|installed| installed['id']} # de los que tienen ebentum instalado nos quedamos con la id de fb
    # obtenemos los usuarios de ebentum que tienen esas uids de en el token de fb
    users = User.in('fbtoken.uid' => fb_uids)
    if users.count > 0
      users.each do |user|
        friends.push user.id
      end
    end
    logger.info('fb friends with ebentum')
    logger.info(friends)
    return friends
  end

end
