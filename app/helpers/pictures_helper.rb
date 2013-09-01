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

end
