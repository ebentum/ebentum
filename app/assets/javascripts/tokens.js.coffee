window.tokens = tokens =

  save_access_token: ()->
    $.ajax
      url: "/fbtokens"
      type: 'POST'
      data: fbtoken: {token: $('#token').val(), expires_at: $('#expires_at').val()}
      dataType: 'json'