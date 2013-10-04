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
        $('div.control-group').removeClass('error')
        $('div.controls input').next().text('')
        # boton en estado loading
        $('#new_password_button').button('loading')
        # asegurarnos que el aviso está oculto
        $('#new_password_success').fadeOut('slow')
      success: (data, status, xhr) ->
        # ponemos el email en el mensaje y lo enseñamos
        txt = $('#new_password_ok_text').text()
        txt = txt.replace('EMAIL', $('#email').val())
        $('#new_password_ok_text').text(txt)
        $('#new_password_success').fadeIn('slow')
        # activar el boton
        $('#new_password_button').button('reset')
      error: (xhr, status, error) ->
        # ponemos los errores
        # hacemos un timeout para que el efecto sea más suave
        setTimeout (->
          errorList = jQuery.parseJSON(xhr.responseText).errors
          $.each errorList, (column, error) ->
            $('#new_password #'+column).next().hide().text(error).fadeIn('slow')
            $('#new_password #'+column).parent().parent().addClass('error')
          # activar el boton
          $('#new_password_button').button('reset')
          ), 2000