Paloma.callbacks["users/show"] = (params) ->

  loadingContent : null

  Paloma.g.initActionButtons()

  $('a[data-toggle="pill"]').on "show.bs.tab", (e) ->
    $('#userpagetabs .footer-option').removeClass('active')
    $('#userpagetabs_mvl .footer-option').removeClass('active')
    $(this).parent().addClass('active')
    Paloma.users.showTab(e.target.hash)

  # por defecto cargar la primera pestaña al entrar a la pagina

  # Como los botones estan repetidos evitar que haga dos ajax
  if $('#header_mvl').css("display") is 'none'
    $('#userpagetabs .footer-option:eq(0) a').click()
  else
    $('#userpagetabs_mvl .footer-option:eq(1) a').click()