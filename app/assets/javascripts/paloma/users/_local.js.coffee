Paloma.users =

  showInfo: (info)->
    $(".tab-content #list_#{info}").removeClass('hidden')

  showError: (error)->
    $(".tab-content #list_error #error_description").html(error)
    $(".tab-content #list_error").removeClass('hidden')

  hideInfo: (info)->
    $(".tab-content #list_#{info}").addClass('hidden')

  showResults : (contentDiv) ->
    $(".tab-content #list_results #{contentDiv}").removeClass('hidden')

  hideResults : ->
    $(".tab-content #list_results .tab-pane").addClass('hidden')

  resetInfoAlerts: ->
    Paloma.users.hideInfo("error")
    Paloma.users.hideInfo("loading")
    Paloma.users.hideInfo("no_userevents")
    Paloma.users.hideInfo("no_userappointments")
    Paloma.users.hideInfo("no_userfollowing")
    Paloma.users.hideInfo("no_userfollowers")


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
          Paloma.users.resetInfoAlerts()
          Paloma.users.hideResults()
          Paloma.users.showInfo("loading")
        success: (data) ->
          Paloma.users.hideInfo("loading")
          if $(".card",data).length > 0
            $(contentDiv).html(data)
            Paloma.users.showResults(contentDiv)
            Paloma.Masonry.loadLayout()
            if $("#events_list").length > 0
              Paloma.Masonry.initPage(contentUrl,"#events_list")
            else
              Paloma.Masonry.initPage(contentUrl,"#users_list")
          else
            Paloma.users.showInfo("no_#{contentDiv.substr(1)}")
          # e.target # activated tab
          # e.relatedTarget # previous tab
        error: (xhr, status, error) ->
          Paloma.users.hideInfo("loading")
          Paloma.users.showError(error)
        complete: ->
          loadingContent = null


  refreshCurrentTab: ->
    tabId = $('#userpagetabs li.active a').attr('href')
    Paloma.users.showTab(tabId)

  refreshTab: (tabId) ->
    # refresh tabId tab only if it's active
    if tabId == $('#userpagetabs li.active a').attr('href')
      Paloma.users.showTab(tabId)


