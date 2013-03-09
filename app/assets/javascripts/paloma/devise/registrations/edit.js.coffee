Paloma.callbacks["devise/registrations/edit"] = (params) ->

  $('#user_image').change ->
    $('#usersImagePreview').empty()
    Paloma.ImageProcessing.loadImageFile("user_image","usersImagePreview")
