module PicturesHelper

  def adjustCardSize(width, height)

    width ||= 230.0
    height ||= 230
    height = height * 1.0
    if width > 230
      # redondear el ancho a la columna
      newWidth = (width / 230.0).round(0)
      # Maximo tres columnas
      if newWidth > 3
        newWidth = 3
      end

      ratio = width / height
      width = (newWidth * 230 ) + ((newWidth-1) * 10)
      height = width / ratio
    end

    {:width => width, :height => height}
  end

  def getPictureData(pictureData, style, type)

    if pictureData
      image_url = pictureData.photo.url(style)
      picSize = adjustCardSize(pictureData.photo_dimensions[style][0], pictureData.photo_dimensions[style][1])
      width = picSize[:width]
      height = picSize[:height]

    else
      image_url = "/photos/#{style}/missing_#{type}.png"
      height = 230
      width = 230
    end

    [image_url, width, height]
  end


end
