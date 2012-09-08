Bagoaz.Router = Ember.Router.extend
  enableLogging: true
  root: Ember.Route.extend
    index: Ember.Route.extend
      route: "/"
      redirectsTo: "events.index"
    events: Ember.Route.extend
      route: "/events"
      showEvent: Ember.Route.transitionTo("show.index")
      createEvent: Ember.Route.transitionTo('create')
      createUser: Ember.Route.transitionTo('users.create')
      cancel: (router, event) ->
        router.get('applicationController.transaction').rollback()
        router.transitionTo('index')
      save: (router, event) ->
        router.get('applicationController.transaction').commit()
        router.transitionTo('index')
      index: Ember.Route.extend
        route: '/'
        connectOutlets: (router) ->
          router.get('applicationController').connectOutlet('events', Bagoaz.Event.find())
      show: Ember.Route.extend
        route: '/:event_id'
        connectOutlets: (router, event) ->
          router.get('applicationController').connectOutlet('event', event)
        index: Ember.Route.extend
          route: '/'
      create: Ember.Route.extend
        route: '/new'
        connectOutlets: (router) ->
          transaction = router.get('store').transaction()
          event = transaction.createRecord(Bagoaz.Event)
          router.get('applicationController').set('transaction', transaction)
          router.get('applicationController').connectOutlet
            viewClass: Bagoaz.NewEventView
            controller: router.get('eventController')
            context: event
        unroutePath: (router, path) ->
          router.get('applicationController.transaction').rollback()
          @_super(router, path)

    users: Ember.Route.extend
      route: "/users"
      cancel: (router, event) ->
        router.get('applicationController.transaction').rollback()
        router.transitionTo('events.index')
      save: (router, event) ->
        router.get('applicationController.transaction').commit()
        router.transitionTo('events.index')
      index: Ember.Route.extend
        route: '/'
        connectOutlets: (router) ->
          router.get('applicationController').connectOutlet('events', Bagoaz.Event.find())
      create: Ember.Route.extend
        route: '/new'
        connectOutlets: (router) ->
          transaction = router.get('store').transaction()
          user = transaction.createRecord(Bagoaz.User)
          router.get('applicationController').set('transaction', transaction)
          router.get('applicationController').connectOutlet
            viewClass: Bagoaz.NewUserView
            controller: router.get('userController')
            context: user
        unroutePath: (router, path) ->
          router.get('applicationController.transaction').rollback()
          @_super(router, path)

      

