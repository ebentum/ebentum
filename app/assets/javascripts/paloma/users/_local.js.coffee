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


  initDeleteAccountBtn: ->

    $(document).on "click", "#confirm_delete_account_btn", (event) ->
      event.preventDefault()
      $.ajax
        url: "/users"
        type: 'DELETE'
        dataType: 'json'
        beforeSend: ->
          $('#confirm_delete_account').modal('hide')
          $('#delete_account_btn').button('loading')
        success: (data, status, xhr) ->
          setTimeout (->
            window.location = '/'
          ), 2000

  initNewPassBtn: ->

    $(document).on "click", "#new_password_button", (event) ->
      event.preventDefault()
      $.ajax
        url: "/users/password"
        type: 'POST'
        data: $('#new_password').serialize()
        dataType: 'json'
        beforeSend: ->
          # quitar las marcas de error
          $('div.control-group').removeClass('error')
          $('div.controls input').next().text('')
          # boton en estado loading
          $('#new_password_button').button('loading')
          # asegurarnos que el aviso está oculto
          $('#new_password_success').fadeOut('slow')
        success: (data, status, xhr) ->
          # ponemos el email en el mensaje y lo enseñamos
          txt = $('#new_password_ok_text').text()
          txt = txt.replace('EMAIL', $('#email').val())
          $('#new_password_ok_text').text(txt)
          $('#new_password_success').fadeIn('slow')
          # activar el boton
          $('#new_password_button').button('reset')
        error: (xhr, status, error) ->
          # ponemos los errores
          # hacemos un timeout para que el efecto sea más suave
          setTimeout (->
            errorList = jQuery.parseJSON(xhr.responseText).errors
            $.each errorList, (column, error) ->
              $('#new_password #'+column).next().hide().text(error).fadeIn('slow')
              $('#new_password #'+column).parent().parent().addClass('error')
            # activar el boton
            $('#new_password_button').button('reset')
            ), 2000