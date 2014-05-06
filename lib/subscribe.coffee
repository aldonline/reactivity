module.exports = ( {notifier, active, run} ) -> ( func, cb ) ->
  mon = null
  stopped = no
  stopper = ->
    stopped = yes
    mon?.removeListener 'change', iter
    # we are the only ones with access to this Monitor
    # we cancel it. this will also cancel
    # the Monitor's notifiers so they can cleanup if necessary
    mon.cancel()
  do iter = ->
    unless stopped
      r = run func
      cb? r.error, r.result, r.monitor, stopper
      mon = r.monitor
      mon?.once 'change', iter
  stopper.stop = stopper
  # calling the stopper function will cancel
  # the internal Monitor which will in turn
  # cancel all its Notifiers
  stopper