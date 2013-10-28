

# http://nodejs.org/api/events.html#events_class_events_eventemitter
ee = 'addListener on once removeListener removeAllListeners setMaxListeners listeners'.split ' '

module.exports =
  copy_event_emitter_methods: ( source, target ) ->
    for n in ee then do (n) ->
      target[n] = -> source[n].apply source, arguments

  compare_semver: ( v1, v2 ) ->
    v1 = ( Number(x) for x in v1.split('.') )
    v2 = ( Number(x) for x in v2.split('.') )
    arr = for x1, i in v1
      x2 = v2[i]
      if x1 > x2
        'GT'
      else if x1 < x2
        'LT'
      else
        'EQ'
    
    for x in arr
      if x is 'GT'
        return 'GT'
      else if x is 'LT'
        return 'LT'
    'EQ'