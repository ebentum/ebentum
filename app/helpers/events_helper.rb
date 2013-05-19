module EventsHelper

  def posterStyle

    styles = [
              "paper-lift",
              "paper-raise",
              "paper-curl",
              "paper-curl-left",
              "paper-curl-right",
              "paper-curve-horiz",
              "paper-curve-above",
              "paper-curve-below",
              "paper-curve-vert",
              "paper-curve-left",
              "paper-curve-right",
              "paper-rotated-right",
              "paper-rotated-left"
            ]

    styles[rand(12)] # si se añade en la lista de arriba aumentar este numero. ¿Estoy ahorrando rendimiento con esto?

  end
end
