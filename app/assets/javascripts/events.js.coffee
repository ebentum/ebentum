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

      $('#event_start_time').timepicker
        timeFormat: "H:i"
        scrollDefaultNow: true
      $('#event_photo').change ->
        $('#imagePreview i').remove()
        loadImageFile()

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
          #$('#event_place').val(place[0].formatted_address)
        #google.maps.event.addListener map, "click", (event) ->
        #  marker.setPosition event.latLng

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

$(document).on "click", "#appoint", (event) ->
  button = $(this)
  $.ajax
    url: "/appointments"
    type: 'POST'
    data: 
      event_id: button.data('eventid')
    dataType: 'json'
    beforeSend: ->
      # boton en estado loading
      $('#appoint').button('loading')
    success: (data, status, xhr) ->
      setTimeout (->
        button.button('reset')
        button.addClass('hide')
        $('#desappoint').removeClass('hide')
        $('#desappoint').data('appointmentid', data.id)
        alert '¡Bien! ¡Ya estas apuntado al evento!'
      ), 2000

$(document).on "click", "#desappoint", (event) ->
  button = $(this)
  $.ajax
    url: "/appointments/"+button.data('appointmentid')
    type: 'DELETE'
    dataType: 'json'
    beforeSend: ->
      # boton en estado loading
      $('#desappoint').button('loading')
    success: (data, status, xhr) ->
      setTimeout (->
        button.button('reset')
        button.addClass('hide')
        $('#appoint').removeClass('hide')
      ), 2000

loadImageFile = (->
  if window.FileReader
    oPreviewImg = null
    oFReader = new window.FileReader()
    rFilter = /^(?:image\/bmp|image\/cis\-cod|image\/gif|image\/ief|image\/jpeg|image\/jpeg|image\/jpeg|image\/pipeg|image\/png|image\/svg\+xml|image\/tiff|image\/x\-cmu\-raster|image\/x\-cmx|image\/x\-icon|image\/x\-portable\-anymap|image\/x\-portable\-bitmap|image\/x\-portable\-graymap|image\/x\-portable\-pixmap|image\/x\-rgb|image\/x\-xbitmap|image\/x\-xpixmap|image\/x\-xwindowdump)$/i
    oFReader.onload = (oFREvent) ->
      unless oPreviewImg
        newPreview = document.getElementById("imagePreview")
        oPreviewImg = new Image()
        oPreviewImg.style.width = (newPreview.offsetWidth).toString() + "px"
        oPreviewImg.style.height = (newPreview.offsetHeight).toString() + "px"
        newPreview.appendChild oPreviewImg
      oPreviewImg.src = oFREvent.target.result

    return ->
      aFiles = document.getElementById("event_photo").files
      return  if aFiles.length is 0
      unless rFilter.test(aFiles[0].type)
        alert "You must select a valid image file!"
        return
      oFReader.readAsDataURL aFiles[0]
  if navigator.appName is "Microsoft Internet Explorer"
    ->
      document.getElementById("imagePreview").filters.item("DXImageTransform.Microsoft.AlphaImageLoader").src = document.getElementById("event_photo").value
)()