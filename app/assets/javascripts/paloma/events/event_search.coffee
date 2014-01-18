Paloma.callbacks["events/event_search"] = (params) ->

  window.navigator.geolocation.getCurrentPosition (position) ->
    lat = position.coords.latitude
    lng = position.coords.longitude
    $.ajax
      url: "/users/update_position"
      type: 'PUT'
      dataType: 'json'
      data:
        lat: lat
        lng: lng
      success: (data, status, xhr) ->
        window.location = '/events/search'




