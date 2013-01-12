$('#events_new').click ->
  $("#modal_windows #events_new_modal").remove()
  $.ajax
    url: "/events/new"
    success: (data) ->
      $("#modal_windows").append data
      $('#events_new_modal').modal()
      $('textarea').autosize({append: "\n"})
      $('.date-picker').datepicker
        autoclose: true
      $('.time-picker').timepicker
        minuteStep: 5
        showInputs: false
        disableFocus: true
        showMeridian: false
      $('#event_photo').change ->
        $('#imagePreview i').remove()
        loadImageFile()


      $("#events_new_modal").modal().on "shown", ->
        map_options =
          center: new google.maps.LatLng(-6.21, 106.84)
          zoom: 11
          mapTypeId: google.maps.MapTypeId.ROADMAP

        map = new google.maps.Map(document.getElementById("map_canvas"), map_options)
        defaultBounds = new google.maps.LatLngBounds(new google.maps.LatLng(-6, 106.6), new google.maps.LatLng(-6.3, 107))
        input = document.getElementById("event_place")
        autocomplete = new google.maps.places.Autocomplete(input)
        autocomplete.bindTo "bounds", map
        marker = new google.maps.Marker(map: map)
        google.maps.event.addListener autocomplete, "place_changed", ->
          place = autocomplete.getPlace()
          if place.geometry.viewport
            map.fitBounds place.geometry.viewport
          else
            map.setCenter place.geometry.location
            map.setZoom 15
          marker.setPosition place.geometry.location

        google.maps.event.addListener map, "click", (event) ->
          marker.setPosition event.latLng


        $("#new_event").validate
          rules:
            "event[name]":
              required: true
            "event[date]":
              required: true
            "event[time]":
              required: true
            "event[place]":
              required: true


$('#modal_windows').on 'click', '#create_event_btn', (event) ->
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