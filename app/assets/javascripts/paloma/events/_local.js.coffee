Paloma.Events =

  initAppointOptionsLayout: (joined) ->

    if joined
      $('#desappoint').removeClass('hide')
      $('#user-action').addClass('option-danger')

    else
      $('#appoint').removeClass('hide')
      $('#user-action').addClass('option-active')

    $(document).on "click", "#confirm_appoint_btn", (event) ->
      button = $(this)
      $.ajax
        url: "/events/add_user/"+button.data('eventid')
        type: 'POST'
        dataType: 'json'
        beforeSend: ->
          # cerrar modal
          $('#confirm_appoint').modal('hide')
          # boton en estado loading
          $('#appoint').button('loading')
        success: (data, status, xhr) ->
          setTimeout (->
            $('#appoint').button('reset')
            $('#appoint').addClass('hide')
            $('#desappoint').removeClass('hide')
            $('#user-action').removeClass('option-active')
            $('#user-action').addClass('option-danger')
            $('#confirm_desappoint_btn').data('appointmentid', data.id)
            # $('p#appointed .badge').text(parseInt($('p#appointed .badge').text())+1)
            $('a#appointed .option-header').text(parseInt($('a#appointed .option-header').text())+1)
            alert '¡Bien! ¡Te has unido al evento!'
          ), 2000

      $.ajax
        url: "/social/share_event_appoint"
        data:
          fb_share: $('#facebook_share').bootstrapSwitch('status')
          tw_share: $('#twitter_share').bootstrapSwitch('status')
          event_id: button.data('eventid')
        dataType: 'json'

    $(document).on "click", "#confirm_desappoint_btn", (event) ->
      button = $(this)
      $.ajax
        url: "/events/remove_user/"+button.data('eventid')
        type: 'DELETE'
        dataType: 'json'
        beforeSend: ->
          # cerrar modal
          $('#confirm_desappoint').modal('hide')
          # boton en estado loading
          $('#desappoint').button('loading')
        complete: (data, status, xhr) ->
          setTimeout (->
            $('#desappoint').button('reset')
            $('#desappoint').addClass('hide')
            $('#appoint').removeClass('hide')
            $('#user-action').removeClass('option-danger')
            $('#user-action').addClass('option-active')
            # $('p#appointed .badge').text(parseInt($('p#appointed .badge').text())-1)
            $('a#appointed .option-header').text(parseInt($('a#appointed .option-header').text())-1)
          ), 2000

  initNewEventOption : ->
    $('#events_new').click ->
      $("#modal_windows #events_new_modal").remove()
      $.ajax
        url: "/events/new"
        success: (data) ->
          $("#modal_windows").append data
          $('#events_new_modal').modal()
