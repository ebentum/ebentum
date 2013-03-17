window.tokens = tokens =

  save_access_token: (user_id) -> 
    $.ajax
      url: "/users/save_token"
      type: 'POST'
      data: token: {token: $('#token').val(), expires_at: $('#expires_at').val()}, user_id: user_id, provider: $('#user_provider').val()
      dataType: 'json'
    