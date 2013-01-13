$('#events_new').click ->
  $("#modal_windows #events_new_modal").remove()
  $.ajax
    url: "/events/new"
    success: (data) ->
      $("#modal_windows").append data
      $('#events_new_modal').modal()
      $('textarea').autosize({append: "\n"})
      $('#event_start_date').datepicker
        autoclose: true
      $('#event_start_time').timepicker()
      $('#event_photo').change ->
        $('#imagePreview i').remove()
        loadImageFile()

      $("#events_new_modal").on "shown", ->
        map_options =
          center: new google.maps.LatLng(-6.21, 106.84)
          zoom: 11
          mapTypeId: google.maps.MapTypeId.ROADMAP

        map = new google.maps.Map(document.getElementById("map_canvas"), map_options)
        defaultBounds = new google.maps.LatLngBounds(new google.maps.LatLng(-6, 106.6), new google.maps.LatLng(-6.3, 107))
        input = document.getElementById("event_place_autocomplete")
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
          $('#event_place').val($('#event_place_autocomplete').val())
          #$('#event_place').val(place[0].formatted_address)
        #google.maps.event.addListener map, "click", (event) ->
        #  marker.setPosition event.latLng


        $("#new_event").validate
          rules:
            "event[name]":
              required: true
            "event[start_date]":
              required: true
              date: true
            "event[start_time]":
              required: true
            #"event[place]":
            #  required: true
          onkeyup: false
          onclick: false
          onfocusout: false


        $('#create_event_btn').click ->
          $("#new_event").submit()


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