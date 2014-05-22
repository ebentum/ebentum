class Fbtoken
  include Mongoid::Document
  include Mongoid::Timestamps

  field :token, type: String
  field :expires_at, type: Integer
  field :autopublish, type: Boolean, default: false
  field :uid, type: String

  attr_accessible :token, :expires_at, :autopublish, :uid

  embedded_in :user

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

  after_create do |fbtoken|
    # obtenemos la lista de usuarios que van a recibir la actividad
    # amigos de fb del usuario que tienen ebentum
    # TODO: y que no seguimos en ebentum TODO
    receiver_ids = get_token_friends_with_ebentum(self.token)#.map{|fbfriend| fbfriend if !current_user.follower_of?(fbfriend)}

    if !receiver_ids.empty?
      Activity.new(
        :verb => "fbregister",
        :actor_id => self.user.id,
        :object_type => "User",
        :object_id => self.user.id,
        :receivers => receiver_ids,
        :date => Time.now
      ).save
    end

  end

end
