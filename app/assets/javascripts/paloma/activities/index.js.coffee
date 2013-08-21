Paloma.callbacks["activities/index"] = (params) ->
  page = 2

  $(document).scroll ->
    if $(window).height() + $(window).scrollTop() >= $(document).height()
      $.ajax(
        url: "/activities"
        data:
          page: page
      ).done (html) ->
        $('#activity_list').append(html)
        page = page + 1