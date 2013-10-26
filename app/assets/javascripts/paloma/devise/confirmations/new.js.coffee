Paloma.callbacks["devise/confirmations/new"] = (params) ->

  $(document).on "click", "#new_confirmation_button", (event) ->
    event.preventDefault()
    $.ajax
      url: "/users/confirmation"
      type: 'POST'
      data: $('#new_confirmation').serialize()
      dataType: 'json'
      beforeSend: ->
        # quitar las marcas de error
        $('div.control-group').removeClass('error')
        $('div.controls input').next().text('')
        # boton en estado loading
        $('#new_confirmation_button').button('loading')
        # asegurarnos que el aviso está oculto
        $('#new_confirmation_success').fadeOut('slow')
      success: (data, status, xhr) ->
        # ponemos el email en el mensaje y lo enseñamos
        txt = $('#new_confirmation_ok_text').text()
        txt = txt.replace('EMAIL', $('#email').val())
        $('#new_confirmation_ok_text').text(txt)
        $('#new_confirmation_success').fadeIn('slow')
        # activar el boton
        $('#new_confirmation_button').button('reset')
      error: (xhr, status, error) ->
        # ponemos los errores
        errorList = jQuery.parseJSON(xhr.responseText).errors
        $.each errorList, (column, error) ->
          $('#new_confirmation #'+column).next().hide().text(error).fadeIn('slow')
          $('#new_confirmation #'+column).parent().parent().addClass('error')
        # activar el boton
        $('#new_confirmation_button').button('reset')

