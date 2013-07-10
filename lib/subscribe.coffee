module.exports = ( {notifier, active, run} ) -> ( func, cb ) ->
  current_monitor = null
  stopper = -> current_monitor?.destroy()
  do iter = ->
    r = run func
    cb? r.error, r.result, r.monitor
    current_monitor = r.monitor
    current_monitor?.onChange iter
  stopper