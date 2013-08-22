

# http://nodejs.org/api/events.html#events_class_events_eventemitter
ee = 'addListener on once removeListener removeAllListeners setMaxListeners listeners'.split ' '

module.exports =
  copy_event_emitter_methods: ( source, target ) ->
    for n in ee then do (n) ->
      target[n] = -> source[n].apply source, arguments






