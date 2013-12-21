Paloma.Tokens =

  save_access_token: (user_id, cb) ->
    _provider = $('#user_provider').val()
    if _provider == 'facebook'
      _data = token: {token: $('#token').val(), expires_at: $('#expires_at').val(), uid: $('#user_uid').val()}, user_id: user_id, provider: _provider
    else if _provider == 'twitter'
      _data = token: {token: $('#token').val(), secret: $('#secret').val(), uid: $('#user_uid').val()}, user_id: user_id, provider: _provider
    $.ajax
      url: "/tokens"
      type: 'POST'
      data: _data
      dataType: 'json'
      success: (data, status, xhr) ->
        cb(null)
      error: (xhr, status, error) ->
        cb(error)