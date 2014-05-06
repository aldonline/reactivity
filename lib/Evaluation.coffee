Monitor  = require './Monitor'
Result   = require './Result'

###
Internal class that wraps an evaluation
###
module.exports = class Evaluation
  
  constructor : ( @func ) ->
  
  run : ->
    try
      new Result
        result:   @func()
        # monitor will be null if no Notifiers
        # were requested downstream
        monitor:  @m?.public_api
    catch e
      new Result
        error:    e
        # monitor will be null if no Notifiers
        # were requested downstream
        monitor:  @m?.public_api
    finally
      delete @func
      delete @m
  
  ###
  An Evaluation owns a Monitor.
  But the Monitor is only created if a Notifier is requested
  ###
  monitor: -> @m ?= new Monitor # lazy

  ###
  You can request N notifiers
  ( they will be provisioned by the current monitor )

  returns 'undefined' if reactivity is not active in this call stack.
  In previous versions we returned a NOOP function.

  While returning undefined imposes a burden on the developer
  ( he has to check for this condition ), by making him aware of the fact
  that reactivity may not always be active, we give him an opportunity to perform
  some optimizations.
  After reviewing several apps I have noticed that this is indeed a very common
  situation.
  ###
  notifier : -> @monitor().evaluation$create_notifier().public_api