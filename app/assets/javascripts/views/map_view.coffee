Bagoaz.MapView = Ember.View.extend
  tagName: "div"
  map: null
  didInsertElement: ->
    @_super()
    Bagoaz.MapData.set "map", new google.maps.Map($("#map").get(0),
      mapTypeId: google.maps.MapTypeId.ROADMAP
      center: new google.maps.LatLng(-33.8665433, 151.1956316)
      zoom: 15
    )