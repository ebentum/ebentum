Paloma.Masonry =

  page: 2
  loadingPage: false
  lastPage: false


  loadLayout: ->

    unless Paloma.g.isMobile()
      $(".masonry_layout").masonry
        itemSelector: ".card"
        columnWidth: 230
        gutter: 10
        isFitWidth: true

    $(".masonry_layout").removeClass 'invisible'

  initPage: (url, container, urlParams={})->

    $(".masonry_layout").masonry()

    $(document).scroll ->
      if $(window).height() + $(window).scrollTop() >= $(document).height() * 0.75
        if Paloma.Masonry.loadingPage is false and Paloma.Masonry.lastPage is false
          Paloma.Masonry.loadingPage = true
          params = Paloma.g.getUrlparams()
          params = $.extend params, urlParams
          params.page = Paloma.Masonry.page


          # TODO: quitar esto esta a pinrel
          date_ = $('#activity_list .card').last().data('activity-date')
          params.last_activity_date = date_ if date_?

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


