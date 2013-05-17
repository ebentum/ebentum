class Picture
  include Mongoid::Document
  include Mongoid::Paperclip

  field :photo_file_name, type: String
  field :photo_content_type, type: String
  field :photo_file_size, type: Integer
  field :photo_updated_at, type: DateTime
  field :photo_dimensions, type: Hash

  has_mongoid_attached_file  :photo, :styles => { :small => "300x300>", :medium => "600x600>" }, :default_url => "/photos/:style/missing.png"
  # , :poster => Proc.new { |instance| instance.poster_resize }

  belongs_to :pictureable, polymorphic: true

  def avatar_url
    photo.url(:small)
  end



  def poster_resize
     geo = Paperclip::Geometry.from_file(Paperclip.io_adapters.for(photo))

     ratio = geo.width/geo.height

     min_width  = 200
     min_height = 200

     if ratio > 1
       # Horizontal Image
       final_height = min_height
       final_width  = final_height * ratio

       if final_width > 200
        # lo que sobresale con respecto al ancho de una columna
        width_dif = (final_width / 200.0) - (final_width / 200)
        if width_dif < 0.25
          # redondear el ancho a la columna
          final_width = ((final_width / 200) * 200 )# + (((final_width / 200)-1) * 10)
          final_height = final_width / ratio
        end
      end

     else
       # Vertical Image
       final_width  = min_width
       final_height = final_width / ratio
     end

     "#{final_width.round}x#{final_height.round}!"
  end

end