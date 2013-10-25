class EventPicture < Picture

  has_mongoid_attached_file :photo,  
                            :styles => {:thumb => "100x100",
                                        :small => "300x300>",
                                        :medium => "600x600>",
                                        :card => Proc.new { |instance| instance.card_resize } },
                            :default_url => "/photos/:style/missing_event.png"

  validates_attachment_size :photo, :less_than => 5.megabytes
end