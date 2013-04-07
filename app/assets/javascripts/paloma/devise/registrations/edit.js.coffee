Paloma.callbacks["devise/registrations/edit"] = (params) ->

  $(document).on "click", "#user_action_button button", (event) ->
    $(this).button('loading')

  $('#user_image').change ->
    $('#userImage').empty()
    Paloma.ImageProcessing.loadImageFile("user_image","userImage")

  $('#imageDeleteButton').on "click", (e) ->
    event.preventDefault()

    $('#confirm_image_delete').modal()

  $(document).on "click", "#confirm_image_delete_btn", (event) ->
    $('#confirm_image_delete').modal('hide')
    $("#user_image_delete").val("1")
    $('#userImage').hide()
    $('#socialUserImage').removeClass('hidden')
    $('#imageDeleteButton').addClass('hidden')
