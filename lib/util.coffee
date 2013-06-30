core = require './core'

module.exports = ->

  {notifier, active, run} = core()

  EQ = (a, b) -> a is b
  delay = -> setTimeout arguments[1], arguments[0]
  build_compare = ( eq ) -> ( out1, out2 ) -> eq( out1.result, out2.result ) and eq( out1.error, out2.error )

  poll = ( f, interval = 100, eq = EQ ) ->
    run_ = -> do (args = arguments) -> run f.apply null, args
    compare = build_compare eq
    ->
      {result, error, notifier} = out = run_()
      if notifier?
        # thank god.
        # We can forget about polling and use the notifier directly
        # let's bubble it up
        notifier.notify notifier()
      else
        # request a new notifier and start polling
        # TODO: listen if notifier gets destroyed and stop polling
        n = notifier()
        do iter = -> # loop and test for equality
          delay interval, ->
            if compare out, run_() then iter() else n()
      # unbox response
      throw out.error if out.error?
      out.result

  subscribe = ( func, cb ) ->
    stopped = no
    stopper = -> stopped = yes
    do iter = ->
      unless stopped
        r = run func
        cb? r.error, r.result, r.notifier, stopper
        r.notifier?.notify iter
    stopper

  { poll, subscribe }