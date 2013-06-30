module.exports = ->

  stack = []
  get_current = -> stack[stack.length - 1]

  construct_notifier = ->
    fired = no
    listeners = null
    notify: ->
      unless fired then fired = yes
      c() for c in listeners
      listener = null
    public:
      fired:  ->     fired
      notify: (f) -> ( listeners ?= [] ).push f

  class Result
    constructor: ( { @error, @result, @notifier } ) ->

  class Evaluation
    constructor : ( @func ) ->
      @n = undefined # lazy
    run : ->
      try
        new Result
          result:   @func()
          notifier: @n?.public
      catch e
        new Result
          error:    e
          notifier: @n?.public
      finally
        delete @func
        delete @n
    notifier : -> do ( n = @n ?= construct_notifier() ) -> -> n.notify()

  run = ( f ) ->
    try
      stack.push ev = new Evaluation f
      ev.run()
    finally
      stack.pop()

  # creates an expiration callback for the current Evaluation
  # if there is no ongoing Evaluation it returns null
  notifier = -> get_current()?.notifier()
  active = -> stack.length isnt 0

  { notifier, active, run }