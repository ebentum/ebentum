Paloma.callbacks["welcome/index"] = (params) ->

  # TODO: ¿Estos dos comentarios?

  #Paloma.g.initActionButtons()

  #Paloma.devise.sessions.initNewSessionBtn()

  $(document).on "click", "#welcome_sign_up_button", (event) ->
    button = $(this)
    form   = button.parents('form')
    event.preventDefault()
    $.ajax
      url: "/users"
      type: 'POST'
      data: $(form).serialize()
      dataType: 'json'
      beforeSend: ->
        $(button).button('loading')
      success: (data, status, xhr) ->
        setTimeout (->
          window.location = '/welcome/sign_up_ok?email='+$('#welcome_sign_up_form #user_email').val()
        ), 2000
      error: (xhr, status, error) ->
        $(form).submit()
