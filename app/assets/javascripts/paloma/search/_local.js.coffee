Paloma.Search =

  searchAjax: ()->

    data_params = {}

    if !$("#event_search_form #distance").hasClass("disabled")
      data_params["distance"] = $("#event_search_form #distance").val()

    if !$("#event_search_form #text").hasClass("disabled")
      data_params["text"] = $("#event_search_form #text").val()

    data_params["days"] = $("#event_search_form #days").val()

    $.ajax
      url: "/events/search"
      data: data_params
      beforeSend: ->
        #$("#events_list").remove()
        $("#events_list").html("")
        #Paloma.users.showInfo("loading")
      success: (data) ->
        $("#events_list").masonry("destroy")
        $("#events_list").html(data)
        Paloma.Masonry.loadLayout()
        $(document).unbind('scroll')
        Paloma.Masonry.page = 2
        Paloma.Masonry.lastPage = false
        Paloma.Masonry.initPage("/events/search", "#events_list", data_params)
