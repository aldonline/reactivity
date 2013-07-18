module.exports = ( {notifier, active, run} ) -> ( func, cb ) ->
  current_monitor = null
  stopper = -> current_monitor?.removeListener 'change', iter
  do iter = ->
    r = run func
    cb? r.error, r.result, r.monitor, stopper
    current_monitor = r.monitor
    current_monitor?.once 'change', iter
  stopper