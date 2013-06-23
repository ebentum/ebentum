Paloma.callbacks["events/show"] = (params) ->
  map_options =
    zoom: 13
    center: new google.maps.LatLng(params["lat"], params["lng"])
    mapTypeId: google.maps.MapTypeId.ROADMAP
  map = new google.maps.Map(document.getElementById("map"), map_options)
  marker_options =
    map: map
    position: new google.maps.LatLng(params["lat"], params["lng"])
  marker = new google.maps.Marker(marker_options)

  if params['joined']
    $('#desappoint').removeClass('hide')
    $('#user-action').addClass('option-danger')

  else
    $('#appoint').removeClass('hide')
    $('#user-action').addClass('option-active')

  # cargar comentarios
  comments.load_event_comments(params['event_id'])
  # configurar scroll de comentarios
  scroll.activate_comments_scroll()