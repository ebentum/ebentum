$('#events_new').click ->
  $("#modal_windows #events_new_modal").remove()
  $.ajax
    url: "/events/new"
    success: (data) ->
      $("#modal_windows").append data
      $('#events_new_modal').modal()
      $('#event_description').autosize({append: "\n"})
      $('#event_start_date').datepicker
        autoclose: true
        language: I18n.locale
        startDate: Date()


      $('#event_start_time').timepicker
        timeFormat: "H:i"
        scrollDefaultNow: true
      $('#event_photo').change ->
        $('#imagePreview').empty()
        Paloma.ImageProcessing.loadImageFile("event_photo","imagePreview")

      $("#events_new_modal").on "shown", ->
        map_options =
          zoom: 13
          mapTypeId: google.maps.MapTypeId.ROADMAP

        map = new google.maps.Map(document.getElementById("map_canvas"), map_options)

        if navigator.geolocation
          browserSupportFlag = true
          navigator.geolocation.getCurrentPosition ((position) ->
            initialLocation = new google.maps.LatLng(position.coords.latitude, position.coords.longitude)
            map.setCenter initialLocation
          )

        input = document.getElementById("place_autocomplete")
        autocomplete = new google.maps.places.SearchBox(input)
        autocomplete.bindTo "bounds", map
        marker = new google.maps.Marker(map: map)

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

        $("#new_event").validate
          rules:
            "event[name]":
              required: true
            "event[start_date]":
              required: true
              date: true
            "event[start_time]":
              required: true
              time: true
            "place_autocomplete":
              valid_place: true

          onkeyup: false
          onclick: false
          onfocusout: false

        $('#create_event_btn').click ->
          $("#new_event").submit()

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
        $('#confirm_desappoint_btn').data('appointmentid', data.id)
        $('p#appointed .badge').text(parseInt($('p#appointed .badge').text())+1)
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
        $('p#appointed .badge').text(parseInt($('p#appointed .badge').text())-1)
      ), 2000
