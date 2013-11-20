Paloma.callbacks["devise/passwords/edit"] = (params) ->

  $(document).on "click", "#edit_password_button", (event) ->
    event.preventDefault()
    $.ajax
      url: "/users/password"
      type: 'PUT'
      data: $('#edit_password').serialize()
      dataType: 'json'
      beforeSend: ->
        # quitar las marcas de error
        $('div.form-group').removeClass('error')
        $('div.controls input').next().text('')
        # boton en estado loading
        $('#edit_password_button').button('loading')
        # asegurarnos que el aviso está oculto
        $('#edit_password_success').fadeOut('slow')
      success: (data, status, xhr) ->
        # redirigir al inicio
        window.location = '/'
      error: (xhr, status, error) ->
        # ponemos los errores
        errorList = jQuery.parseJSON(xhr.responseText).errors
        $.each errorList, (column, error) ->
          $('#edit_password #'+column).next().hide().text(error).fadeIn('slow')
          $('#edit_password #'+column).parent().parent().addClass('error')
        # activar el boton
        $('#edit_password_button').button('reset')