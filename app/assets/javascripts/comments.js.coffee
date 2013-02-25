window.comments = comments =

  load_event_comments: (event_id) ->
    $.ajax
      url: "/comments"
      type: 'GET'
      data:
        event_id: event_id
      dataType: 'html'
      success: (data, status, xhr) ->
        $('#comments').html(data)
    # provider = $('#user_provider').val()
    # if provider == 'facebook'
    #   $.ajax
    #     url: "/fbtokens"
    #     type: 'POST'
    #     data: fbtoken: {token: $('#token').val(), expires_at: $('#expires_at').val(), user_id: user_id}
    #     dataType: 'json'
    # else if provider == 'twitter'
    #   $.ajax
    #     url: "/twtokens"
    #     type: 'POST'
    #     data: twtoken: {token: $('#token').val(), secret: $('#secret').val(), user_id: user_id}
    #     dataType: 'json'
    