Paloma.callbacks["events/search"] = (params) ->

  Paloma.Masonry.initPage("/events/search","#events_list")

  $(document).on "change", "#event_search_form select", ->
    $('#event_search_form').submit()

