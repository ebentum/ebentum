Paloma.callbacks["devise/registrations/edit"] = (params) ->

  Paloma.Pictures.mainImageForm('user_main_picture_form', 'user_main_picture_input', 'user_action_button', "/photos/medium/missing_user.png")

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
        window.location = '/'

  $(document).on 'change', '#facebook_post, #twitter_post', ->
    provider = $(this).data('provider')
    token_id = $(this).data('token')
    console.log provider
    console.log token_id
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

  $("#facebook").on "change", (e, data) ->
    switchContainer = $(this).parent()
    if switchContainer.hasClass 'switch-on'
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

  $("#twitter").on "change", (e, data) ->
    switchContainer = $(this).parent()
    if switchContainer.hasClass 'switch-on'
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