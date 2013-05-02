class Picture
  include Mongoid::Document
  include Mongoid::Paperclip

  embedded_in :pictureable, polymorphic: true

  has_mongoid_attached_file  :photo,
    :styles => lambda { |a|
                        { :thumb => "100x100#",
                          :small => "300x300>",
                          :medium => "600x600>"}
                          # :user_defined => "#{a.instance.width}x#{a.instance.height}#" }
                      }

end