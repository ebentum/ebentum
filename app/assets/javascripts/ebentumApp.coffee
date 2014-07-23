window.ebentumApp =


  deleteCookie: ( name ) ->
    document.cookie = name + '=; expires=Thu, 01 Jan 1970 00:00:01 GMT;';

  closeSession: ->
    closeBtn = $("#ebentum_native_close_session")
    if closeBtn?
      ebentumApp.deleteCookie("ebentum_userid")
      ebentumApp.deleteCookie("ebentum_username")
      # dar tiempo a que se borren las cookies antes de navegar (= cura en salud)
      setTimeout =>
        closeBtn.trigger("click");
      , 500


  setNativeCookie: ->

    setCookie = (cname, cvalue, exdays) ->
      d = new Date()
      d.setTime(d.getTime() + (exdays*24*60*60*1000))
      expires = "expires="+d.toGMTString()
      document.cookie = cname + "=" + cvalue + "; " + expires
    ####

    setCookie("ebentum_native", "true",3650)

  isNative: ->

    getCookie = (cname) ->
      name = cname + "="
      ca = document.cookie.split(";")
      i = 0

      while i < ca.length
        c = ca[i].trim()
        return c.substring(name.length, c.length)  if c.indexOf(name) is 0
        i++
      ""

    getCookie("ebentum_native") is "true"



  shareEventText: ->

    eventTitle = $('.event-dscr').text().trim()
    eventUrl = $('#event-short-url').text().trim()

    EbentumAppNative.setShareText("'#{eventTitle}': " + eventUrl)