Paloma.callbacks["devise/registrations/new"] = (params) ->

  $(document).on "click", "#sign_up_button", (event) ->
    button = $(this)
    Paloma.devise.registrations.sign_up_flow(button, event)