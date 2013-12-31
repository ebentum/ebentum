Paloma.DateTimes =

  format: (selector)->
    console.log "date times format"
    if not selector?
      selector = $('body')
      Paloma.DateTimes.initTimeAgosUpdateInterval()

    Paloma.DateTimes.formatTimeAgos(selector)

    # TODO: formatear fechas normales etc

  formatTimeAgos: (selector) ->
    # Formatear timeagos
    $('.format-timeago', selector).each ->
      value = $(this).data('datevalue')
      newValue = moment(value, "YYYY-MM-DD HH:mm:ss Z").fromNow();
      $(this).text(newValue)


  initTimeAgosUpdateInterval: ->
    console.log "initTimeAgosUpdateInterval"
    # cada minuto actualizar los timeagos de la pantalla
    updateFn = () ->
      Paloma.DateTimes.format($('body'))
      console.log "update times"

    setInterval updateFn, 60000 # 60 secs

  formatDateSpans: ->
    $(".format-date").each ->
      value = $(this).text()
      newValue = moment(value, "YYYY-MM-DD HH:mm:ss")
      $(this).text newValue.format("LLLL")