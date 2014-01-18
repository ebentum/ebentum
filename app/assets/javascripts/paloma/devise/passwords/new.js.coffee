Paloma.callbacks["devise/passwords/new"] = (params) ->

  $(document).on "click", "#new_password_button", (event) ->
    event.preventDefault()
    $.ajax
      url: "/users/password"
      type: 'POST'
      data: $('#new_password').serialize()
      dataType: 'json'
      beforeSend: ->
        # quitar las marcas de error
        $('div.form-group').removeClass('has-error')
        $('div.controls input').next().text('')
        # boton en estado loading
        $('#new_password_button').button('loading')
        # asegurarnos que el aviso está oculto
        $('#new_password_success').addClass('hide')
      success: (data, status, xhr) ->
        # ponemos el email en el mensaje y lo enseñamos
        txt = $('#new_password_ok_text').text()
        txt = txt.replace('EMAIL', $('#email').val())
        $('#new_password_ok_text').text(txt)
        $('#new_password_success').toggleClass('hide')
        # activar el boton
        $('#new_password_button').button('reset')
      error: (xhr, status, error) ->
        # ponemos los errores
        errorList = jQuery.parseJSON(xhr.responseText).errors
        $.each errorList, (column, error) ->
          $('#new_password #'+column).next().hide().text(error).fadeIn('slow')
          $('#new_password #'+column).parent().parent().addClass('has-error')
        # activar el boton
        $('#new_password_button').button('reset')