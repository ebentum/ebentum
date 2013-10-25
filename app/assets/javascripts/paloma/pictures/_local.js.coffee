Paloma.Pictures =

  mainImageForm: (formSubmitButtonId) ->
    $("#main_picture_link").click (e) ->
      e.preventDefault()
      $("#main_picture_field").click()

      $("#main_picture_form").fileupload
        dataType: "json"
        start: (e, data) ->
          $("#main_picture_upload_progress").removeClass("hidden")
          $("#"+formSubmitButtonId).addClass("disabled")
        progressall: (e, data) ->
          progress = parseInt(data.loaded / data.total * 100, 10)-10
          $("#main_picture_upload_progress .bar").css "width", progress + "%"
        done: (e, data) ->
          $("#main_picture_upload_progress .bar").css "width", 100 + "%"
          $('#main_picture_preview').attr("src", data.result.avatar_url)
          $('#main_picture_id').val(data.result._id)
          $("#main_picture_upload_progress .bar").css "width", 0
          $("#main_picture_upload_progress").addClass("hidden")
          $("#"+formSubmitButtonId).removeClass("disabled")
        fail: (e, data) ->
          $("#main_picture_upload_progress .bar").css "width", 0
          $("#main_picture_upload_progress").addClass("hidden")
          $("#"+formSubmitButtonId).removeClass("disabled")

    $('#main_picture_delete_button').on "click", (e) ->
      event.preventDefault()
      $('#main_picture_delete').modal()

    $(document).on "click", "#main_picture_delete_button", (event) ->
      $.ajax
        type: "POST"
        url: $('#main_picture_form').attr("action")
        dataType: "json"
        data:
          _method: "delete"

        complete: ->
          $('#main_picture_delete').modal('hide')
          $('#main_picture_delete_button').addClass('hidden')