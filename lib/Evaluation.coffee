Monitor  = require './Monitor'
Result   = require './Result'

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
  notifier : -> do ( m = @m ?= (new Monitor) ) ->
    m.evaluation$create_notifier()?.public_api