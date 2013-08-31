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


        # // Put here global code that can be used by all callbacks,
    # //   regardless which folder they're from.

    # // Example:

    # //   variableName: value;

    # //   functionName: function(params){
    # //     alert('Paloma');
    # //   };

    # // To use the variable and function:
    # //   Paloma.g.variableName
    # //   Paloma.g.functionName(params);



