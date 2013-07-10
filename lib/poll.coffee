module.exports = ( {notifier, active, run} ) ->
  
  EQ = ( a, b ) -> a is b
  delay = -> setTimeout arguments[1], arguments[0]
  build_compare = ( eq ) -> ( out1, out2 ) ->
    eq( out1.result, out2.result ) and eq( out1.error, out2.error )

  poll = ( f, interval = 100, eq = EQ ) ->
    run_ = -> do ( args = arguments ) -> run f.apply null, args
    compare = build_compare eq
    ->
      if active()
        {result, error, monitor} = out = run_()
        if monitor?
          # thank god. no need for polling
          # let's bubble it up ( create a new notifier and set it as change handler )
          monitor.onChange notifier()
        else
          # request a new notifier and start polling
          b = notifier()
          # we stop polling if notifier is cancelled
          stopped = no
          b.onCancel -> stopped = yes

          # poll
          do iter = -> 
            unless stopped
              delay interval, ->
                unless stopped
                  # ignore if result does not change
                  if compare out, run_() then iter() else b()

        # now that we are ready setting up the polling interval
        # we return normally
        throw out.error if out.error?
        out.result
      else
        f()

  poll