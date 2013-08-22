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
        monitor:  @m?.public_api
    catch e
      new Result
        error:    e
        monitor:  @m?.public_api
    finally
      delete @func
      delete @m
  
  ###
  An evaluation owns a monitor
  ###
  monitor: -> @m ?= new Monitor # lazy

  ###
  You can request N notifiers
  ( they will be provisioned by the current monitor )
  ###
  notifier : -> @monitor().evaluation$create_notifier()?.public_api