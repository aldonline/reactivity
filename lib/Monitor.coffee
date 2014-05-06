Notifier = require './Notifier'
Base     = require './Base'
util     = require './util'

module.exports = class Monitor extends Base

    states:
      ready:        null
      changed:      'handle_change'
      cancelled:    'handle_cancel'

    cancelled_notifiers: 0

    constructor: ->
      @notifiers = []
      @public_api = f = (h) => @once 'change', h
      util.copy_event_emitter_methods @, f
      f.cancel = => @user$cancel()
      f.state =  => @state
    
    handle_cancel: ->
      @emit 'cancel'
      @emit 'destroy'
      @removeAllListeners()

    handle_change: ->
      @emit 'change'
      @emit 'destroy'
      @removeAllListeners()

    # called during evaluation phase by the Evaluation object itself
    evaluation$create_notifier: =>
      @notifiers.push n = new Notifier @
      n

    # called by one of our notifiers to inform us that it has been destroyed
    notifier$cancel_notifier: =>
      if @notifiers.length is ++@cancelled_notifiers
        # there are no notifiers left. we tell our user that monitoring has
        # been cancelled.
        # we don't need to cancel our notifiers since they are already cancelled
        @transition 'cancelled'

    # called by one of our notifiers to inform us that the user has called change()
    notifier$change: -> @transition 'changed', =>
      # we cancel all active notifiers
      # notice that one notifier will be in 'changed' state
      # which is why we filter
      x.monitor$cancel() for x in @notifiers when x.state is 'ready'
    
    # called by the user whenever he wants to destroy this monitor
    # we cancel notifiers
    user$cancel: => @transition 'cancelled', =>
      x.monitor$cancel() for x in @notifiers when x.state is 'ready'
