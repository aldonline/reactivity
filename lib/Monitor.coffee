Notifier = require './Notifier'
Base     = require './Base'

module.exports = class Monitor extends Base

    states:
      ready:        null
      changed:      'handle_change'
      cancelled:    'handle_cancel'
      destroyed:    null 

    destroyed_notifiers: 0

    constructor: ->
      @notifiers = []
      @public_api =
        onChange: (f) => @on 'change', f # deprecated
        onCancel: (f) => @on 'cancel', f # deprecated
        on:       (e, l) => @on e, l
        removeListener:      (e, l) => @removeListener e, l   
        once:     (e, l) => @once e, l               
        destroy:  @user$destroy
        state:   => @state
    
    handle_cancel: -> @emit 'cancel'
    handle_change: -> @emit 'change'

    # called during evaluation phase by the Evaluation object itself
    evaluation$create_notifier: =>
      @notifiers.push n = new Notifier @
      n

    # called by one of our notifiers to inform us that it has been destroyed
    notifier$destroy_notifier: =>
      if @notifiers.length is ++@destroyed_notifiers
        # there are no notifiers left. we tell our user that monitoring has
        # been cancelled.
        # we don't need to cancel our notifiers since they are all destroyed
        @transition 'cancelled'

    # called by one of our notifiers to inform us that the user has called fire()
    notifier$fire: -> @transition 'changed', =>
      # we cancel all active notifiers
      # notice that one notifier will be in 'fired' state
      # which is why we filter
      x.monitor$cancel() for x in @notifiers when x.state is 'ready'
    
    # called by the user whenever he wants to destroy this monitor
    # we cancel notifiers
    user$destroy: => @transition 'destroyed', =>
      x.monitor$cancel() for x in @notifiers when x.state is 'ready'
