Paloma.callbacks["users/show"] = (params) ->

  loadingContent : null

  Paloma.g.initActionButtons()

  $('a[data-toggle="pill"]').on "show", (e) ->
    $('#userpagetabs .footer-option').removeClass('active')
    $(this).parent().addClass('active')
    Paloma.users.showTab(e.target.hash)

  # por defecto cargar la primera pestaña al entrar a la pagina
  $('#userpagetabs .footer-option:eq(0) a').click()