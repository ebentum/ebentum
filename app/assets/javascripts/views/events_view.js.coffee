Bagoaz.EventsView = Ember.View.extend
  templateName: 'events/index',
  didInsertElement: ->
  	init_masonry()
