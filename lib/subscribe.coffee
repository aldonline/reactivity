module.exports = ( {notifier, active, run} ) -> ( func, cb ) ->
  mon = null
  stopper = -> mon?.removeListener 'change', iter
  do iter = ->
    r = run func
    cb? r.error, r.result, r.monitor, stopper
    mon = r.monitor
    mon?.once 'change', iter
  stopper