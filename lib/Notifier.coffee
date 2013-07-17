Base = require './Base'

###
The Notifier is the main class used when creating reactive functions
###

module.exports = class Notifier extends Base
    states:
      ready:        null
      # a notifier is cancelled when its monitor is destroyed
      cancelled:    'handle_cancel'
      fired:        null
      destroyed:    null 

    constructor: (@monitor) ->
      # we don't expose all members
      # remember that this module is shared across code from different parties
      @public_api = f = => @user$fire()
      f.onCancel      = (l) => @on 'cancel', l
      f.on            = (e, l) => @on e, l
      f.off           = (e, l) => @off e, l
      f.once          = (e, l) => @once e, l  
      f.state         = => @state
      f.destroy       = @user$destroy
      f.fire          = @user$fire
      f


    handle_cancel: -> x() for x in @listeners 'cancel'

    # called by the user when he wishes to inform a change
    user$fire: => @transition 'fired', => @monitor.notifier$fire()

    # called by the user if he decides that this notifier
    # is no longer necessary
    user$destroy: => @transition 'destroyed', => @monitor.notifier$destroy_notifier()
    
    # called by our parent monitor in the event that
    # its user called monitor.destroy()
    # or if another notifier has fired
    monitor$cancel: -> @transition 'cancelled'