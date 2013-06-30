# Native Reactivity for Javascript

![Native Reactivity for Javascript logo](https://raw.github.com/aldonline/njsr/master/etc/nrjs-250.png)

Native Reactivity for Javascript ( aka NR.js ) is a micro-library that allows native functions and expressions in Javascript
to become Natively Reactive. Which is a fancy way of saying that they can notify other functions their return value changes.

The technique is so simple that it "blends into" the language. There is no need to create
"Observable" objects, Event Emitters or evaluate expressions in a sublanguage.
Any Javascript function can be Natively Reactive. And any function that depends on a Natively Reactive function becomes Natively Reactive automatically.

There is no need to explicitly define dependency relations between functions.

# Installation

## NPM

Install via NPM

    npm install nr

```javascript
var NR = require('nr')
```

## Browser ( TODO )

Include the following JS file

```html
<script src="https://raw.github.com/aldonline/nrjs/master/dist/nr.min.js"></script>
```

The global NR object is attached to the root scope ( window )

    var NR = window.NR

# Overview

# Creating a Natively Reactive Function

Functions throw an invalidation event up the stack.
However, because the stack is transient and won't exist in the future, functions
that wish to notify a change need to request a callback so they can
throw the event in the future.

```javascript
function time(){
  var notifier = NR() // request a notifier
  setTimeout( notifier, 1000 ) // call it in 1000MS
  return new Date().getTime()
}
```

The caller of the function, on the other hand, will have an opportunity to register
a listener to be notified when any of the functions that participated in the evaluation are invalidated.
At this point you can decide to re-evaluate the expression.

# Consuming a Natively Reactive Function

```javascript
var r = NR( time ) // run the function in a native reactive context
var time = r.result
var notifier = r.notifier
if ( notifier != null ){ // at least one notifier was registered downstream
  notifier.add( function(){
    console.log( "we should reevaluate the expression" )
    })
  }
```

# FAQ

## Why do we need a "Standard" library?

In order to be able to combine libraries developed by different people at different
times we need to agree on a common way of notifying changes up the stack.

This means ( at the least ) sharing a global object where invalidators and notifiers meet each other.
NR.js provides a microlibrary and a set of conventions.
If we all follow them, Javascript automatically becomes a MUCH more powerful language.

## Why does't the Invalidation event provide me with a way to inspect previous and current values?

Because an expression may depende on several reactive functions,
the Invalidation event you catch on the top of the stack may come from any of them.
The value of this specific function is not important.
What's important is the result of evaluating the complete expression.

## Where does this idea come from?

Like all good ideas and patterns in software they have been discoverd and rediscovered over and over again by venturous programmers. The author of this library can attest that its first encounter with this pattern was as part of a strategy to invalidate caches when calling complex stored procedures probably 15 years ago. The implementation details were a bit different but the principle was the same. Naturally, this idea was ported to Javascript over a decade ago.

Lately it has popped up in several places. The most notable of them all is probably the Meteor.js framework, where it is tightly coupled with the framework.

Just search for "reactive" on NPM.


