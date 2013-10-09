module.exports = ( {notifier, active, run} ) -> ( func, cb ) ->
  mon = null
  stopped = no
  stopper = ->
    stopped = yes
    mon?.removeListener 'change', iter
  do iter = ->
    unless stopped
      r = run func
      cb? r.error, r.result, r.monitor, stopper
      mon = r.monitor
      mon?.once 'change', iter
  stopper.stop = stopper
  stopper