Paloma.Pictures =

  mainImageForm: (objectId, formSubmitButtonId, missingImage) ->
    $("#"+objectId+" #main_picture_link").click (e) ->
      e.preventDefault()
      $("#"+objectId+" #main_picture_field").click()

      $("#"+objectId+" #main_picture_form").fileupload
        dataType: "json"
        start: (e, data) ->
          $("#"+objectId+" #main_picture_upload_progress").removeClass("hidden")
          $("#"+objectId+" #"+formSubmitButtonId).addClass("disabled")
        progressall: (e, data) ->
          progress = parseInt(data.loaded / data.total * 100, 10)-10
          $("#"+objectId+" #main_picture_upload_progress .bar").css "width", progress + "%"
        done: (e, data) ->
          $("#"+objectId+" #main_picture_upload_progress .bar").css "width", 100 + "%"
          $('#'+objectId+' #main_picture_preview').attr("src", data.result.avatar_url)
          $('#'+objectId+' #main_picture_id').val(data.result._id)
          $("#"+objectId+" #main_picture_upload_progress .bar").css "width", 0
          $("#"+objectId+" #main_picture_upload_progress").addClass("hidden")
          $("#"+objectId+" #"+formSubmitButtonId).removeClass("disabled")
        fail: (e, data) ->
          $("#"+objectId+" #main_picture_upload_progress .bar").css "width", 0
          $("#"+objectId+" #main_picture_upload_progress").addClass("hidden")
          $("#"+objectId+" #"+formSubmitButtonId).removeClass("disabled")

    $('#'+objectId+' #main_picture_delete_button').on "click", (e) ->
      event.preventDefault()
      $('#"+objectId+" #main_picture_delete').modal()

    $(document).on "click", "#"+objectId+" #main_picture_confirm_delete_button", (event) ->
      $('#'+objectId+' #main_picture_id').val("")
      $('#'+objectId+' #main_picture_delete').modal('hide')
      $('#'+objectId+' #main_picture_preview').attr("src", missingImage)
