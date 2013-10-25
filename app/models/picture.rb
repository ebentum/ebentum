class Picture
  include Mongoid::Document
  include Mongoid::Paperclip

  field :photo_file_name, type: String
  field :photo_content_type, type: String
  field :photo_file_size, type: Integer
  field :photo_updated_at, type: DateTime
  field :photo_dimensions, type: Hash
                            
  

  belongs_to :pictureable, polymorphic: true

  def avatar_url
    photo.url(:small)
  end


      # - pwidth = event.photo_dimensions["poster"][0]
      # - pheight = event.photo_dimensions["poster"][1] * 1.0
      # - if pwidth > 200
      #   -# lo que sobresale con respecto al ancho de una columna
      #   - pwidht_dif = (pwidth / 200.0) - (pwidth / 200)
      #   - if pwidht_dif < 0.25
      #     -#   -# redondear el ancho a la columna
      #     - pratio = pwidth / pheight
      #     - pwidth = ((pwidth / 200) * 200 ) + (((pwidth / 200)-1) * 10)
      #     - pheight = pwidth / pratio

      # -# - if pwidth > 200
      # -#   - pratio = pwidth / pheight
      # -#   -# redondear el ancho a columnas
      # -#   - pwidth = ((pwidth / 200).round) * 200
      # -#   - pheight = pwidth / pratio


  def card_resize
    # geo = Paperclip::Geometry.from_file(Paperclip.io_adapters.for(photo))
    geo = Paperclip::Geometry.from_file(photo.queued_for_write[:original])

    ratio = geo.width / (geo.height * 1.0)

    min_width  = 230
    min_height = 230

    if ratio > 1
      # Horizontal Image
      final_height = min_height
      final_width  = final_height * ratio

      # if final_width > 200
      #   # lo que sobresale con respecto al ancho de una columna
      #   width_dif = (final_width / 200.0) - (final_width / 200)
      #   if width_dif < 0.25
      #     # redondear el ancho a la columna
      #     final_width = ((final_width / 200) * 200 )# + (((final_width / 200)-1) * 10)
      #     final_height = final_width / ratio
      #   end
      # end

    else
      # Vertical Image
      final_width  = min_width
      final_height = final_width / ratio
    end

    "#{final_width.round}x#{final_height.round}!"
  end


end