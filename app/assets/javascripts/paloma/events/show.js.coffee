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

  if params['user_appointment_id'] > 0
    $('#desappoint').removeClass('hide')
    $('#desappoint').data('appointmentid', params['user_appointment_id'])
  else
    $('#appoint').removeClass('hide')

  # cargar comentarios
  comments.load_event_comments(params['event_id'])