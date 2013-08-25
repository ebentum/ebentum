Paloma.DateTimes =

  format: (selector=$('body'))->
    Paloma.DateTimes.formatTimeAgos(selector)

  formatTimeAgos: (selector) ->
    # Formatear timeagos
    $('.format-timeago', selector).each(
                               () ->
                                    value = $(this).text()
                                    newValue = moment(value, "YYYY-MM-DD HH:mm:ss Z").fromNow();
                                    $(this).text(newValue).toggleClass('hidden')
                            )