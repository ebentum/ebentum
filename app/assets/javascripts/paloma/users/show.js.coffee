Paloma.callbacks["users/show"] = (params) ->

  loadingContent : null

  $('a[data-toggle="pill"]').on "show", (e) ->
    contentDiv = e.target.hash
    contentUrl = $(contentDiv).data("url")
    contentParams = {no_layout: true}
    contentParams = $.extend contentParams, $(contentDiv).data("params")

    if loadingContent
      loadingContent.abort()

    loadingContent = $.ajax
        url: contentUrl
        data: contentParams
        beforeSend: ->
          # TODO
          $(contentDiv).parent('#error').toggleClass('hidden')
          $(contentDiv).html("Loading...")
        success: (data) ->
          $(contentDiv).html(data)
          # e.target # activated tab
          # e.relatedTarget # previous tab
        error: (xhr, status, error) ->
          # TODO
          $(contentDiv).html(error)
          $(contentDiv).parent('#error').html(error)
          $(contentDiv).parent('#error').toggleClass('hidden')
        complete: ->
          loadingContent = null

  # por defecto cargar la primera pestaña al entrar a la pagina
  $('#userpagetabs li:eq(0) a').click()