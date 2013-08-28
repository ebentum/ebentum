Paloma.callbacks["activities/index"] = (params) ->
  page = 2

  $(document).scroll ->
    if $(window).height() + $(window).scrollTop() >= $(document).height() * 0.75
      $.ajax(
        url: "/activities"
        data:
          page: page
      ).done (html) ->
        content = $(html)
        Paloma.DateTimes.format(content)
        $('#activity_list').append(content).masonry( 'appended', content )
        page = page + 1