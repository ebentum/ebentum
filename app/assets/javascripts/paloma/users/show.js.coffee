Paloma.callbacks["users/show"] = (params) ->

  loadingContent : null

  $('a[data-toggle="pill"]').on "show", (e) ->
    Paloma.users.showTab(e.target.hash)

  # por defecto cargar la primera pestaña al entrar a la pagina
  $('#userpagetabs .footer-option:eq(0) a').click()