Paloma.callbacks["events/search"] = (params) ->

  #Paloma.Masonry.initPage("/events/search","#events_list")

  $(document).on "change", "#event_search_form select", (event) ->
    Paloma.Search.searchAjax()
    true

  $(document).on "click", "#filter_type #by_distance", ->
    $("#filter_type #by_distance").addClass("active")
    $("#filter_type #by_name").removeClass("active")

    $("#event_search_form #distance").removeClass("hidden disabled")
    $("#event_search_form #text").addClass("hidden disabled")


  $(document).on "click", "#filter_type #by_name", ->
    $("#filter_type #by_name").addClass("active")
    $("#filter_type #by_distance").removeClass("active")

    $("#event_search_form #text").removeClass("hidden disabled")
    $("#event_search_form #distance").addClass("hidden disabled")

  $(document).on "click", "#event_search_form #search_button", ->
    Paloma.Search.searchAjax()
    event.preventDefault();
