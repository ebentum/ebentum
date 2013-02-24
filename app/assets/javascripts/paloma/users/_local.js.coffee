Paloma.users =

  showTab: (contentDiv)->
    contentUrl = $(contentDiv).data("url")
    contentParams = {no_layout: true}
    contentParams = $.extend contentParams, $(contentDiv).data("params")

    if loadingContent
      loadingContent.abort()

    loadingContent = $.ajax
        url: contentUrl
        data: contentParams
        beforeSend: ->
          # TODO
          $(contentDiv).parent('#error').toggleClass('hidden')
          $(contentDiv).html("Loading...")
        success: (data) ->
          $(contentDiv).html(data).imagesLoaded ->
            $(".masonry_layout").masonry
              itemSelector: ".box"
              isFitWidth: true
          # e.target # activated tab
          # e.relatedTarget # previous tab
        error: (xhr, status, error) ->
          # TODO
          $(contentDiv).html(error)
          $(contentDiv).parent('#error').html(error)
          $(contentDiv).parent('#error').toggleClass('hidden')
        complete: ->
          loadingContent = null

  refreshCurrentTab: ->
    tabId = $('#userpagetabs li.active a').attr('href')
    Paloma.users.showTab(tabId)

  refreshTab: (tabId) ->
    # refresh tabId tab only if it's active
    if tabId == $('#userpagetabs li.active a').attr('href')
      Paloma.users.showTab(tabId)
