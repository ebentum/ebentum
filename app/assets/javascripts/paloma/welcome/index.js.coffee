Paloma.callbacks["welcome/index"] = (params) ->

  Paloma.g.initActionButtons()

  Paloma.devise.sessions.initNewSessionBtn()

  $(document).on "click", "#welcome_sign_up_button", (event) ->
    event.preventDefault()
    $.ajax
      url: "/users"
      type: 'POST'
      data: $('#welcome_sign_up_form').serialize()
      dataType: 'json'
      beforeSend: ->
        $('#welcome_sign_up_button').button('loading')
      success: (data, status, xhr) ->
        setTimeout (->
          window.location = '/welcome/sign_up_ok?email='+$('#welcome_sign_up_form #user_email').val()
        ), 2000
      error: (xhr, status, error) ->
        $("#welcome_sign_up_form").submit()
