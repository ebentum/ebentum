class Fbtoken
  include Mongoid::Document
  include Mongoid::Timestamps

  field :token, type: String
  field :expires_at, type: Integer
  field :autopublish, type: Boolean, default: false
  field :uid, type: String

  attr_accessible :token, :expires_at, :autopublish, :uid

  embedded_in :user

  def get_token_friends_with_ebentum
    # instanciamos el objeto fb
    fb = Koala::Facebook::API.new(self.token)
    # uids de fb de nuestros amigos de fb que tienen ebentum
    fb_uids = fb.get_connections("me", "friends", :fields => "id, installed") # amigos de fb. obtenemos id e installed (ebentum)
              .select {|user| user.key?('installed')} # nos quedamos con los que tienen ebentum instalado
              .map {|installed| installed['id']} # de los que tienen ebentum instalado nos quedamos con la id de fb
    # obtenemos los usuarios de ebentum que tienen esas uids de en el token de fb
    logger.info('fb_uids en fbtoken.rb')
    logger.info(fb_uids)
    users = User.where('fbtoken.uid' => fb_uids)
    users
  end

  after_create do |fbtoken|
    # obtenemos la lista de usuarios que van a recibir la actividad
    # amigos de fb del usuario que tienen ebentum #y que no seguimos en ebentum
    receivers = get_token_friends_with_ebentum#.map{|fbfriend| fbfriend if !current_user.follower_of?(fbfriend)}
    logger.info('receivers en fbtoken.rb')
    logger.info(receivers)

    # sacamos las ids
    receiver_ids = receivers.map{|r| r.id}

    logger.info('receiver_ids en fbtoken.rb')
    logger.info(receiver_ids)

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
