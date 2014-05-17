window.ebentumApp =


  deleteCookie: ( name ) ->
    document.cookie = name + '=; expires=Thu, 01 Jan 1970 00:00:01 GMT;';

  closeSession: ->
    closeBtn = $("#ebentum_native_close_session")
    if closeBtn?
      closeBtn.trigger("click");
      ebentumApp.deleteCookie("ebentum_userid")
      ebentumApp.deleteCookie("ebentum_username")