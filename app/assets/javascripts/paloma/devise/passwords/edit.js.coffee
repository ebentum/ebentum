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
        $('div.control-group').removeClass('error')
        $('div.controls input').next().text('')
        # boton en estado loading
        $('#edit_password_button').button('loading')
        # asegurarnos que el aviso está oculto
        $('#edit_password_success').fadeOut('slow')
      success: (data, status, xhr) ->
        setTimeout (->
          # redirigir al inicio
          window.location = '/'
        ), 2000
      error: (xhr, status, error) ->
        # ponemos los errores
        # hacemos un timeout para que el efecto sea más suave
        setTimeout (->
          errorList = jQuery.parseJSON(xhr.responseText).errors
          $.each errorList, (column, error) ->
            $('#edit_password #'+column).next().hide().text(error).fadeIn('slow')
            $('#edit_password #'+column).parent().parent().addClass('error')
          # activar el boton
          $('#edit_password_button').button('reset')
          ), 2000