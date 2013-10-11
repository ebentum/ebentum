Paloma.callbacks["devise/registrations/edit"] = (params) ->

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



  $("#image-preview-link").click (e) ->
    e.preventDefault()
    $("#picture_photo").click()

    $("#edit_user_image").fileupload
      dataType: "json"
      start: (e, data) ->
        $("#image-upload-progress").removeClass("hidden")
        $("#user_action_button").addClass("disabled")
      progressall: (e, data) ->
        progress = parseInt(data.loaded / data.total * 100, 10)
        $("#image-upload-progress .bar").css "width", progress + "%"
      done: (e, data) ->
        $('#image-preview').attr("src", data.result.avatar_url)
        $('#main_picture_id').val(data.result._id)
        $("#image-upload-progress .bar").css "width", 0
        $("#image-upload-progress").addClass("hidden")
        $("#user_action_button").removeClass("disabled")
      fail: (e, data) ->
        $("#image-upload-progress .bar").css "width", 0
        $("#image-upload-progress").addClass("hidden")
        $("#user_action_button").removeClass("disabled")


  $('#imageDeleteButton').on "click", (e) ->
    event.preventDefault()
    $('#confirm_image_delete').modal()

  $(document).on "click", "#confirm_image_delete_btn", (event) ->
    $('#confirm_image_delete').modal('hide')
    $("#user_image_delete").val("1")
    $('#userImage').hide()
    $('#socialUserImage').removeClass('hidden')
    $('#imageDeleteButton').addClass('hidden')






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