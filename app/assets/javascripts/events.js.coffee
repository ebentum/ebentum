$('#events_new').click ->
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
        loadImageFile()

      input = document.getElementById("event_place")

      autocomplete = new google.maps.places.Autocomplete(input)
      google.maps.event.addListener autocomplete, "place_changed", ->
        place = autocomplete.getPlace()
        $('#event_lat').val(place.geometry.location.lat())
        $('#event_lng').val(place.geometry.location.lng())

      




$('#modal_windows').on 'click', '#create_event_btn', (event) ->
  $("#new_event").submit()

# $("#modal_windows").on "click", "#new_event_save", (event) ->
#   $.ajax
#     url: "/events"
#     type: 'POST'
#     data: $('#new_event').serialize()
#     dataType: 'json'
#     success: (data) ->
#       alert('success')
#     error: (xhr, status, error) ->
#       errorList = jQuery.parseJSON(xhr.responseText)
#       $.each errorList, (column, error) ->
#         $('#event_'+column).parent().append('<span class="help-inline">'+error+'</span>')
#         $('#event_'+column).parent().parent().addClass('error')

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