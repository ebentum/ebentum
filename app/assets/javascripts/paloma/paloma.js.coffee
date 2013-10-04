window.Paloma = {callbacks:{}};

Paloma.g =

  getUrlparams: ->
    params = {}
    href_split = window.location.href.split("?")
    if href_split.length > 1
      param_array = href_split[1].split("&")
      for i of param_array
        x = param_array[i].split("=")
        params[x[0]] = x[1]
    params

  initActionButtons: ->
    $(document).on "click", "#user_action_button button", (event) ->
      $(this).button('loading')


