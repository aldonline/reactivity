Base = require './Base'
util = require './util'

###
The Notifier is the main class used when creating reactive functions
###

module.exports = class Notifier extends Base
    states:
      ready:        null
      cancelled:    'handle_cancel'
      changed:      'handle_change'

    constructor: (@monitor) ->
      # we don't expose all members
      # remember that this module is shared across code from different parties
      @public_api = f = => @user$change()
      util.copy_event_emitter_methods @, f

      f.state         = => @state
      f.cancel        = @user$cancel
      f.change        = @user$change

    handle_cancel: ->
      @emit 'cancel'
      @emit 'destroy'
      @removeAllListeners()

    handle_change: ->
      @emit 'change'
      @emit 'destroy'
      @removeAllListeners()

    # called by the user when he wishes to inform a change
    user$change: => @transition 'changed', => @monitor.notifier$change()

    # called by the user if he decides that this Notifier
    # is no longer necessary
    # we inform our Monitor. if at some point all the Notifiers
    # that belong to a given Monitor have cancelled
    # the Monitor will also be cancelled
    user$cancel: => @transition 'cancelled', => @monitor.notifier$cancel_notifier()
    
    # called by our parent Monitor in the event that
    # its user called Monitor.cancel()
    # or if another Notifier has fired
    monitor$cancel: -> @transition 'cancelled'