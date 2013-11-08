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
          $('#appoint').button('reset')
          $('#appoint').addClass('hide')
          $('#desappoint').removeClass('hide')
          $('#user-action').removeClass('option-active')
          $('#user-action').addClass('option-danger')
          $('#confirm_desappoint_btn').data('appointmentid', data.id)
          # $('p#appointed .badge').text(parseInt($('p#appointed .badge').text())+1)
          $('a#appointed .option-header').text(parseInt($('a#appointed .option-header').text())+1)

      $.ajax
        url: "/social/share_event_appoint"
        data:
          fb_share: !$('#facebook_share').hasClass('toggle-off')
          tw_share: !$('#twitter_share').hasClass('toggle-off')
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
          $('#desappoint').button('reset')
          $('#desappoint').addClass('hide')
          $('#appoint').removeClass('hide')
          $('#user-action').removeClass('option-danger')
          $('#user-action').addClass('option-active')
          # $('p#appointed .badge').text(parseInt($('p#appointed .badge').text())-1)
          $('a#appointed .option-header').text(parseInt($('a#appointed .option-header').text())-1)

  initEventFormOption : (action, id = null) ->
    if action == "new"
      url = "/events/new"
    else if action == "edit"
      url = "/events/"+id+"/edit"

    $('#events_'+action).click ->
      $("#modal_window").remove()
      $.ajax
        url: url
        success: (data) ->
          $("#modal_windows").append data
          $('#modal_window').modal()

  initEventForm : (action) ->
    $("#modal_window").on "hidden", ->
      $("#modal_window").remove()
    $("#modal_window").on "shown", ->

      $('#event_description').autosize({append: "\n"})
      $('#event_start_date').datepicker
        autoclose: true
        language: I18n.locale
        startDate: Date()

      $('#event_start_time').timepicker
        timeFormat: "H:i"
        scrollDefaultNow: true

      # $("#image-preview-link").click (e) ->
      #   e.preventDefault()
      #   $("#picture_photo").click()

      $('#create_event_btn').click ->
        if !$(this).hasClass("disabled")
          $("."+action+"_event").submit()

      Paloma.Pictures.mainImageForm('event_main_picture_form', 'event_main_picture_input', 'create_event_btn', "/photos/medium/missing_event.png")

      map_options =
        zoom: 13
        mapTypeId: google.maps.MapTypeId.ROADMAP

      map = new google.maps.Map(document.getElementById("map_canvas"), map_options)
      marker = new google.maps.Marker(map: map)

      if navigator.geolocation
        browserSupportFlag = true

        if $('#event_lat').val() != ""
          initialLocation = new google.maps.LatLng($('#event_lat').val(), $('#event_lng').val())
          map.setCenter initialLocation
          marker.setPosition initialLocation
        else
          navigator.geolocation.getCurrentPosition ((position) ->
            initialLocation = new google.maps.LatLng(position.coords.latitude, position.coords.longitude)
            map.setCenter initialLocation
          )

      input = document.getElementById("place_autocomplete")
      autocomplete = new google.maps.places.SearchBox(input)
      autocomplete.bindTo "bounds", map
      

      google.maps.event.addListener autocomplete, "places_changed", ->
        place = autocomplete.getPlaces()

        if !place[0]
          marker.setMap(null)
          $('#event_lat').val(null)
          $('#event_lng').val(null)
          $('#event_place').val(null)
          return
        else
          marker.setMap(map)

        if place[0].geometry.viewport
          map.fitBounds place[0].geometry.viewport
        else
          map.setCenter place[0].geometry.location
          map.setZoom 15
        marker.setPosition place[0].geometry.location
        $('#event_lat').val(place[0].geometry.location.lat())
        $('#event_lng').val(place[0].geometry.location.lng())
        $('#event_place').val($('#place_autocomplete').val())

      $.validator.addMethod "time", ((value, element) ->
        @optional(element) or /^(([0-1]?[0-9])|([2][0-3])):([0-5]?[0-9])?$/i.test(value)
      ), "Please enter a valid time."

      $.validator.addMethod "valid_place", ((value, element) ->
        if $('#event_place').val() == ""
          false
        else
          true
      ), "You must indicate a correct place."

      $.validator.addMethod "dateRange", (->
        today = new moment()
        event_date = new moment($("#event_start_date").val(),$("#event_start_date").data('date-format').toUpperCase())
        return true  if event_date >= today
        false
      ), "Please specify a correct date."

      $("#new_event").validate
        rules:
          "event[name]":
            required: true
          "event[start_date]":
            required: true
            date: true
            dateRange: "event_start_date"
          "event[start_time]":
            required: true
            time: true
          "place_autocomplete":
            valid_place: true
        onkeyup: false
        onclick: false
        onfocusout: false