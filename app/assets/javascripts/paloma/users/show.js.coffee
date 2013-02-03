Paloma.callbacks["users/show"] = (params) ->

  $('a[data-toggle="pill"]').on "show", (e) ->
    content_div = e.target.hash
    $.ajax
      url: "/events"
      data: {no_layout: true}
      beforeSend: ->
        $(content_div).html("Loading...")
      success: (data) ->
        $(content_div).html(data)
        # e.target # activated tab
        # e.relatedTarget # previous tab
      error: (xhr, status, error) ->
        $(content_div).html(error)

  # por defecto cargar la primera pestaña al entrar a la pagina
  $('#userpagetabs li:eq(0) a').click()