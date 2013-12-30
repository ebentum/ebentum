Paloma.devise.registrations =

  user_confirmation_required:  ->
    omniauth_email        = $('#user_omniauth_email').val()
    user_email            = $('#email').val()
    if omniauth_email != user_email
      confirmation_required = 'true'
    else
      confirmation_required = 'false'
    confirmation_required

  sign_up_flow: (button, event) ->
    sign_up_button = $(button)
    sign_up_error  = $(sign_up_button).parents('.card').prev()
    form           = $(button).parents('form')
    event.preventDefault()
    # controlar si hay que confirmar el email
    $('#user_user_confirmation_required').val(Paloma.devise.registrations.user_confirmation_required())
    $.ajax
      url: "/users"
      type: 'POST'
      data: $(form).serialize()
      dataType: 'json'
      beforeSend: ->
        # quitar las marcas de error
        $('div.form-group').removeClass('has-error')
        $(sign_up_error).addClass('hide')
        $('div.controls input').next().text('')
        # boton en estado loading
        $(sign_up_button).button('loading')
      success: (data, status, xhr) ->
        if $('#user_user_confirmation_required').val() == 'false'
          # guardar token de acceso
          Paloma.Tokens.save_access_token data._id, (err) ->
            # redirigir al inicio
            window.location = '/events/'

        else
          # guardar token de acceso
          Paloma.Tokens.save_access_token data._id, (err) ->
            window.location = '/welcome/sign_up_ok?email='+$('#email').val()

      error: (xhr, status, error) ->
        # ponemos los errores
        errorList = jQuery.parseJSON(xhr.responseText).errors
        errorText = ''
        $.each errorList, (column, error) ->
          $(sign_up_error).removeClass('hide')
          $('#new_user #'+column).parent().parent().addClass('has-error')
          campo = I18n.t('attributes.'+column)
          errorText += campo+': '+error+'<br>'
        # activar el boton
        if errorText
          $('#sign_up_error_text', sign_up_error).html(errorText)
        $(sign_up_button).button('reset')