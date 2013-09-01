Paloma.devise.registrations =

  user_confirmation_required: ->
    omniauth_email        = $('#user_omniauth_email').val()
    user_email            = $('#email').val()
    if omniauth_email != user_email
      confirmation_required = 'true'
    else
      confirmation_required = 'false'
    confirmation_required




