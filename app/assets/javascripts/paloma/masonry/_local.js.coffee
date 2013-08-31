Paloma.Masonry =

  page: 2
  loadingPage: false
  lastPage: false

  loadLayout: (url, container)->
    $(".masonry_layout").masonry
      itemSelector: ".card"
      columnWidth: 230
      gutter: 10
      isFitWidth: true

    $(document).scroll ->
      if $(window).height() + $(window).scrollTop() >= $(document).height() * 0.75
        if Paloma.Masonry.loadingPage is false and Paloma.Masonry.lastPage is false
          Paloma.Masonry.loadingPage = true
          params = Paloma.g.getUrlparams()
          params.page = Paloma.Masonry.page
          $.ajax(
            url: url
            data: params
          ).done (html) ->
            content = $(html)
            if content.length > 0
              Paloma.DateTimes.format(content)
              $(container).append(content).masonry( 'appended', content )
              Paloma.Masonry.page = Paloma.Masonry.page + 1
            else
              Paloma.Masonry.lastPage = true
            Paloma.Masonry.loadingPage = false

