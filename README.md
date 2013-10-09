# Reactivity.io
##The Native Reactivity Standard for Javascript

*Native Reactivity* is a very simple "hack" that allows native functions and expressions in Javascript
to become Reactive. Which is a fancy way of saying that **they can notify consumers when their result changes**.

For example:

```javascript


function getA(){ return 5 }
function getB(){ return 6 }

function getAplusB(){ return getA() + getB() } 



```

Using *Native* Reactivity gives you one very important feature for free:
Changes are propagated transparently up the call stack.
Native Reactivity is automatically transitive - any function that depends on a reactive function is reactive itself.

This means that there is no need to explicitly declare dependencies.

The only "catch" is that everyone has to use the **same** implementation. 
This is the reason behind the reactivity.io effort. It defines an API and provides a cannonical implementation.

# Installation

## NPM

```shell
npm install reactivity
```

```javascript
var reactivity = require('reactivity')
```

## Browser ( TODO )

Include the following JS file

```html
<script src="https://raw.github.com/aldonline/reactivity.js/master/dist/reactivity.min.js"></script>
```

In the browser, the global reactivity object is attached to the root scope ( window )

```javascript
var reactivity = window.reactivity
```

If the object is already present then the library won't mess things up.
It will proxy calls to the pre-existing implementation.

# Overview

# Creating a Natively Reactive Function

Functions throw an *invalidation event* up the stack.
However, because the stack is transient and won't exist in the future, functions
that wish to notify a change need to request a callback so they can
throw the event in the future.

Requesting this callback will make sure that any consuming functions get a chance to ask for notifiers
on the other side.

```javascript
function time(){
  var notifier = reactivity.notifier()  // request a notifier
  setTimeout( notifier, 1000 ) // call it in 1000MS
  return new Date().getTime()
}
```

The caller of the function will have an opportunity to register
a listener to be notified when any of the functions that participated in the evaluation are invalidated.
At this point you can decide to re-evaluate the expression.

# Consuming a Natively Reactive Function


```javascript
// run the function in a reactive context
// instead of returning the result or throwing an error
// it will return an object with three properties: result, error and monitor
var r = reactivity.run( time )

// we are interested in the result
var time = r.result

// and the monitor
var monitor = r.monitor

// the monitor is null unless the function is reactive
// ( or depends on a reactive function - reactivity is transitive )
// in this case we know that time() is reactive since we created it ourselves
// but we still check for illustrative purposes
if ( monitor != null ){ 
    
  // and we can now wait to be notifier of a change
  monitor.onChange( function(){
    console.log( "we should reevaluate the expression" )
  })
}
```

# API

There are two different APIs. One for each side of the problem ( consuming VS publishing )


signature | shortcut | description
--- | --- | ---
reactivity.run( f:Function ):Result | reactivity(f) | runs code in a reactive context
Result::result | x | x
Result::error | x | x



## Consumer Side

### reactivity.run( reactiveFunction : Function ):Result

Runs a reactive function and returns a *Result* object

Shortcut:

```javascript
reactivity(func)
```

### reactivity.subscribe( reactiveFunction:Function )

Runs a reactive function repeatedly.

Shortcut:

```javascript
reactivity( reactiveFunction, callback )

// example

reactivity( reactiveFunction, function(error, result, monitor){
  // ...
})


```

### reactivity.poll( reactiveFunc : Function, interval : Number ):Function

Transform any function into a reactive function by repeatedly evaluating it and
comparing its result.

Using this method is considered bad practice in general.

```javascript
var reactiveFunc = reactivity.poll( func, 500 )
```


Shortcut:

```javascript
reactivity( func, 500 )
```

## Result Object

The Result object has three properties:

* result
* error
* monitor

## Monitor Object

### monitor.state():String

states: ready, changed, destroyed, cancelled

### monitor.onChange( handler : Function )

Registers a callback that will be called whenever the monitored function changes.

### monitor.onCancel( handler : Function )

### monitor.destroy( )


## Producer API

### reactivity.notifier( ):Notifier

Returns a Notifier

Shortcut:

```javascript
reactivity()
```

### reactivity.active():Boolean

## Notifier

### notifier.fire()

Shortcut

```javascript
notifier()
```

### notifier.destroy()

### notifier.state():String

States: ready, cancelled, fired, destroyed

### notifier.onCancel( handler:Function )

# Advanced

## Creating a Reactive function


## Consuming a Reactive function



# FAQ

## Why do we need a "Standard" library?

In order to be able to combine libraries developed by different people at different
times we need to agree on a common way of notifying changes up the stack.

This means ( at the least ) sharing a global object where invalidators and notifiers meet each other.
reactivity.js provides a microlibrary and a set of conventions.
If we all follow them, Javascript automatically becomes a MUCH more powerful language.

## Why does't the Notifier provide me with a way to inspect previous and current values?

Because an expression may depend on several reactive functions,
the Invalidation event you catch at the top of the stack may come from any of them.
The value of this specific function is not important.
What's important is the result of evaluating the complete expression.

## Where does this idea come from?

Like all good ideas and patterns in software they have been discovered and rediscovered over and over again.
Using a global object to allow producers talk to consumers up on the stack is common when invalidating
database caches for example.

Lately it has popped up in several places. The pattern is usually tightly coupled with the host program/framework.

## Why doesn't the module use classic EventEmitters?

* Adding an event emitter implementation adds significant overhead.
* It increments contact surface
* There is more than one event emitter API style ( DOM vs Node, for example )
* The places where you register notifiers are usually very locally scoped ( right after an evaluation for example ) and adding more than one listener is not a common use case.
* You can always build a more complex subscription model on top




