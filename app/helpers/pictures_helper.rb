module PicturesHelper

  require "browser"

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

  def getCardStyles(is_mobile, image_url, width, height)

    if is_mobile
      card_style = "background: url('#{image_url}'); background-repeat:no-repeat; background-attachment:fixed; background-position:center top; background-size: 100%; background-color: #fff"
      image_style = "width: #{width}px; height: 230px;"
      card_class = "col-xs-12"
    else
      card_style = "background: url('#{image_url}') repeat; max-width: #{width}px; background-size: #{width}px #{height}px; background-color: #fff"
      image_style = "width: #{width}px; height: #{height}px;"
      card_class = ""

    end

    {:card_style => card_style, :image_style => image_style, :card_class => card_class }
  end


end
