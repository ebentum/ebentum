Paloma.callbacks["events/show"] = (params) ->

  # Inicializar mapa
  map_options =
    zoom: 13
    center: new google.maps.LatLng(params["lat"], params["lng"])
    mapTypeId: google.maps.MapTypeId.ROADMAP
  map = new google.maps.Map(document.getElementById("map"), map_options)
  marker_options =
    map: map
    position: new google.maps.LatLng(params["lat"], params["lng"])
  marker = new google.maps.Marker(marker_options)

  # inicializar opciones de unirse
  Paloma.Events.initAppointOptionsLayout(params['joined'])

  # cargar comentarios
  Paloma.Comments.load_event_comments(params['event_id'])
  Paloma.Comments.initLayout()

