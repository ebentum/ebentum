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

  # cargar comentarios
  Paloma.Comments.load_event_comments(params['event_id'])
  Paloma.Comments.initLayout()

  $(document).on "click", "#confirm_delete_event_btn", (event) ->
    user_id = $(this).data('userid')
    event.preventDefault()
    $.ajax
      url: "/events/"+$(this).data('eventid')
      type: 'DELETE'
      dataType: 'json'
      beforeSend: ->
        $('#confirm_delete_event').modal('hide')
        $('#delete_event_btn').button('loading')
      success: (data, status, xhr) ->
        window.location = '/users/'+user_id
