Bagoaz.EventsView = Ember.View.extend
  templateName: 'events/index',
    didInsertElement: ->
      #Solución chapu de momento
      #init_masonry();
   	  setTimeout('init_masonry();',500);

