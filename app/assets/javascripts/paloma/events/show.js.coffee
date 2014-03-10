Paloma.callbacks["events/show"] = (params) ->

  # inicializar opciones de unirse
  Paloma.Events.initAppointOptionsLayout(params['joined'])

  Paloma.Events.initEventFormOption("edit", params['event_id'])

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


  $('a[data-toggle="pill"]').on "show.bs.tab", (e) ->
    $('.events-tab-options .footer-option').removeClass('active')

    $(this).parent().addClass('active')
    Paloma.Events.showTab(e.target.hash, params)

  # Mostrar la 1era pestaña
  $('#comments-tab-option').click()


