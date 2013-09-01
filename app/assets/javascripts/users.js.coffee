$(document).on "click", "#sign_up_button", (event) ->
  event.preventDefault()
  # controlar si hay que confirmar el email
  $('#user_user_confirmation_required').val(user_confirmation_required())
  $.ajax
    url: "/users"
    type: 'POST'
    data: $('#new_user').serialize()
    dataType: 'json'
    beforeSend: ->
      # quitar las marcas de error
      $('div.control-group').removeClass('error')
      $('#sign_up_error').fadeOut('slow')
      $('div.controls input').next().text('')
      # boton en estado loading
      $('#sign_up_button').button('loading')
    success: (data, status, xhr) ->
      if $('#user_user_confirmation_required').val() == 'false'
        # guardar token de acceso
        Paloma.Tokens.save_access_token(data._id)
        setTimeout (->
          # redirigir al inicio
          window.location = '/events/'
        ), 2000
      else
        # guardar token de acceso
        tokens.save_access_token(data._id)
        setTimeout (->
          window.location = '/welcome/sign_up_ok?email='+$('#email').val()
        ), 2000

    error: (xhr, status, error) ->
      # ponemos los errores
      # hacemos un timeout para que el efecto sea más suave
      setTimeout (->
        errorList = jQuery.parseJSON(xhr.responseText).errors
        errorText = ''
        $.each errorList, (column, error) ->
          $('#sign_up_error').fadeIn('slow')
          $('#new_user #'+column).parent().parent().addClass('error')
          campo = I18n.t('attributes.'+column)
          errorText += campo+': '+error+'<br>'
        # activar el boton
        if errorText
          $('#sign_up_error_text').html(errorText)
        $('#sign_up_button').button('reset')
      ), 2000

$(document).on "click", "#welcome_sign_up_button", (event) ->
  event.preventDefault()
  $.ajax
    url: "/users"
    type: 'POST'
    data: $('#welcome_sign_up_form').serialize()
    dataType: 'json'
    beforeSend: ->
      $('#welcome_sign_up_button').button('loading')
    success: (data, status, xhr) ->
      setTimeout (->
        window.location = '/welcome/sign_up_ok?email='+$('#welcome_sign_up_form #user_email').val()
      ), 2000
    error: (xhr, status, error) ->
      $("#welcome_sign_up_form").submit()


$(document).on "click", "#confirm_delete_account_btn", (event) ->
  event.preventDefault()
  $.ajax
    url: "/users"
    type: 'DELETE'
    dataType: 'json'
    beforeSend: ->
      $('#confirm_delete_account').modal('hide')
      $('#delete_account_btn').button('loading')
    success: (data, status, xhr) ->
      setTimeout (->
        window.location = '/'
      ), 2000

user_confirmation_required = (->
  omniauth_email        = $('#user_omniauth_email').val()
  user_email            = $('#email').val()
  if omniauth_email != user_email
    confirmation_required = 'true'
  else
    confirmation_required = 'false'
  confirmation_required
)

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
      # hacemos un timeout para que el efecto sea más suave
      setTimeout (->
        errorList = jQuery.parseJSON(xhr.responseText).errors
        $.each errorList, (column, error) ->
          $('#new_confirmation #'+column).next().hide().text(error).fadeIn('slow')
          $('#new_confirmation #'+column).parent().parent().addClass('error')
        # activar el boton
        $('#new_confirmation_button').button('reset')
        ), 2000

$(document).on "click", "#sign_in_button", (event) ->
  event.preventDefault()
  $.ajax
    url: "/users/sign_in"
    type: 'POST'
    data: $('#sign_in').serialize()
    dataType: 'json'
    beforeSend: ->
      # quitar las marcas de error
      $('div.control-group').removeClass('error')
      $('#sign_in_error').fadeOut('slow')
      # boton en estado loading
      $('#sign_in_button').button('loading')
    success: (data, status, xhr) ->
      # redirigir al inicio
      window.location = '/events/'
    error: (xhr, status, error) ->
      # ponemos el error
      # hacemos un timeout para que el efecto sea más suave
      setTimeout (->
        if xhr.status is 401
          error = jQuery.parseJSON(xhr.responseText).error
          $('#sign_in_error_text').text(error)
          $('#sign_in_error').fadeIn('slow')
          $('#sign_in #email, #sign_in #password').parent().parent().addClass('error')
          # activar el boton
          $('#sign_in_button').button('reset')
      ), 2000

$(document).on 'switch-change', '#facebook_post, #twitter_post', ->
  provider = $('input', $(this)).data('provider')
  token_id = $('input', $(this)).data('token')
  $.ajax
    url: "/tokens/"+token_id
    type: 'PUT'
    dataType: 'json'
    data:
      provider: provider

$(document).on 'click', '#import_fb, #import_tw', ->
  provider = $(this).data('provider')
  $('#confirm_import_social_btn').data('provider', provider)
  $('#confirm_import_social').modal()

$(document).on 'click', '#confirm_import_social_btn', ->
  provider = $(this).data('provider')
  $.ajax
    url: "/social/get_social_data"
    type: 'GET'
    dataType: 'json'
    data:
      provider: provider
    success: (data, status, xhr) ->
      $('#confirm_import_social').modal('hide')
      $('#user_complete_name').val(data.complete_name) if $('#import_complete_name').is(':checked')
      $('#user_location').val(data.location) if $('#import_location').is(':checked')
      $('#user_web').val(data.web) if $('#import_web').is(':checked')
      $('#user_bio').val(data.bio) if $('#import_bio').is(':checked')
      $('#userImage img').attr('src', data.image) if $('#import_image').is(':checked')
      $('#image_url').val(data.image) if $('#import_image').is(':checked')

$("#facebook").on "switch-change", (e, data) ->
  if !$(this).hasClass('toggle-off')
    window.location = '/users/facebook_login?state=/users/edit.'+$('#user_id').val()
  else
    # borrar app del perfil
    FB.getLoginStatus (response) ->
      if response.status == 'connected'
        FB.api "/me/permissions", "DELETE", (response) ->
          console.log response if !response
    # borrar token
    $.ajax
      url: "/tokens/"+$('input', $(this)).data('token')
      type: 'DELETE'
      data:
        provider: 'facebook'
      dataType: 'json'
      success: (data, status, xhr) ->
        $('#facebook_post').bootstrapSwitch('toggleActivation')
        $('#facebook_post').bootstrapSwitch('setState', false)
        # quitar boton de importar desde FB
        $('a.btn-facebook').fadeOut 'slow', ->
          $('a.btn-facebook').remove()
          $('#option-facebook').toggleClass('footer-option')
          $('#option-facebook').toggleClass('option-facebook')

    # ocultamos la opción de publicar
    $('#publish_facebook').fadeOut('slow')

$("#twitter").on "switch-change", (e, data) ->
  if !$(this).hasClass('toggle-off')
    window.location = '/users/twitter_login?state=/users/edit.'+$('#user_id').val()
  else
    # borrar token
    $.ajax
      url: "/tokens/"+$('input', $(this)).data('token')
      type: 'DELETE'
      data:
        provider: 'twitter'
      dataType: 'json'
      success: (data, status, xhr) ->
        $('#twitter_post').bootstrapSwitch('toggleActivation')
        $('#twitter_post').bootstrapSwitch('setState', false)
        # quitar boton de importar desde TW
        $('a.btn-twitter').fadeOut 'slow', ->
          $('a.btn-twitter').remove()
          $('#option-twitter').toggleClass('footer-option')
          $('#option-twitter').toggleClass('option-info')

    # ocultamos la opción de publicar
    $('#publish_twitter').fadeOut('slow')