module.exports = ->

  stack = []

  class Notifier
    fired: no
    listeners: null
    fire: =>
      unless @fired
        @fired = yes
        c() for c in @listeners
        delete @listeners
    # build public API ( doesn't expose private members )
    pub: => @_pub ?=
      notify: (f) => if @fired then f() else ( @listeners ?= [] ).push f
      fired: => @fired

  class Result
    constructor: ( { @error, @result, @notifier } ) ->

  class Evaluation
    n: null
    constructor : ( @func ) ->
    run : ->
      try
        new Result
          result:   @func()
          notifier: @n?.pub()
      catch e
        new Result
          error:    e
          notifier: @n?.pub()
      finally
        delete @func
        delete @n
    notifier : -> do ( n = @n ?= (new Notifier) ) -> -> n.fire()

  run = ( f ) ->
    try
      stack.push ev = new Evaluation f
      ev.run()
    finally
      stack.pop()

  # creates an expiration callback for the current Evaluation
  # if there is no ongoing Evaluation it returns null
  notifier = -> stack[stack.length - 1]?.notifier()
  active = -> stack.length isnt 0

  { notifier, active, run }