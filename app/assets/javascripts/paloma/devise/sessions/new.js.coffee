Paloma.callbacks["devise/sessions/new"] = (params) ->

  Paloma.g.initActionButtons()

  $(document).on "click", "#sign_in_button", (event) ->
    event.preventDefault()
    $.ajax
      url: "/users/sign_in"
      type: 'POST'
      data: $('#sign_in').serialize()
      dataType: 'json'
      beforeSend: ->
        # quitar las marcas de error
        $('div.form-group').removeClass('has-error')
        $('#sign_in_error').fadeOut('slow')
        # boton en estado loading
        $('#sign_in_button').button('loading')
      success: (data, status, xhr) ->
        # redirigir al inicio
        window.location = '/events/'
      error: (xhr, status, error) ->
        # ponemos el error
        if xhr.status is 401
          error = jQuery.parseJSON(xhr.responseText).error
          $('#sign_in_error_text').text(error)
          $('#sign_in_error').fadeIn('slow')
          $('#sign_in #email, #sign_in #password').parent().parent().addClass('has-error')
          # activar el boton
          $('#sign_in_button').button('reset')


