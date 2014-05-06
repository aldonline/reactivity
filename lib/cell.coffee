
class Box

  # throws error or returns value
  do_get: -> if @is_error then throw @v else @v

  # returns true if something changed, false otherwise
  do_set: ( e, r ) ->
    new_v = if ( is_error = e? ) then e else r
    return false if new_v is @v
    @is_error = is_error
    @v = new_v
    yes

  do_set_auto: ->
    a = arguments
    if a.length is 2 then return @do_set.apply @, a # f( error, response )
    # otherwise it has to be 1
    # ( we don't check since this is an internal helper for this module )
    if a[0] instanceof Error
      @do_set a[0], null
    else
      @do_set null, a[0]


class NotifierCollector
  constructor: ->
    @_arr = []
  
  add: ( n ) ->
    @_arr.push n
    n.on 'destroy', =>
      unless @_batch
        # GC etiquette: we remove our reference to this notifier
        # TODO: use splice to avoid creating new array?
        @_arr = ( x for x in @_arr when x isnt n )

  cancel_all: ->
    @_batch = yes
    n.cancel() for n in @_arr
    @_arr = []
    undefined

  change_all: ->
    @_batch = yes
    n.change() for n in @_arr
    @_arr = []
    undefined




module.exports = ( {notifier, active} ) -> cell = ->

  box = new Box
  destroyed = no

  notifiers = undefined

  # the cell function that will be returned
  # ( closes over the above variables )
  f = ->
      
    if destroyed
      throw new Error 'Cannot get/set values on a cell that has been destroyed'

    a = arguments

    # -- handle get()
    if a.length is 0
      # register invalidator
      if active() then ( notifiers ?= new NotifierCollector ).add notifier()
      # return
      return box.do_get()

    # -- handle different types of set()
    if box.do_set_auto.apply box, a # is true if value changes

      # call all accumulated notifiers
      if ( notifiers_ = notifiers )?
        notifiers = undefined
        notifiers_.change_all( )
    
    # setting a value does not return anything
    # this is part of the cell spec
    undefined
  
  f.destroy = ->
    unless destroyed
      n.cancel() for n in notifiers
      destroyed = yes

  f


