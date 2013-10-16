# Reactivity.io

THIS README IS NOT YET FINISHED.
HOWEVER, THE LIBRARY IS FINISHED AND BATTLE TESTED.
TAKE A LOOK AT `/examples`.

## The Problem


Let's say we want to have an HTML Paragraph showing the current time.

```javascript

$('p').text( getTime() )

```

This value will be set once ( when the script is run ) but won't change when the actual time changes, right?

If we had a way of listening to changes on the result of the getTime() function, we could use this mechanism
to periodically update our UI.

```javascript

on_change( getTime, function( t ){
  $('p').text( t )
})

```

We could easily create this on_change function by constantly polling getTime() for changes.

```javascript
... TODO: ugly code with setTimeout()s
```

However, if we relied upon this strategy for a large application we would end up with lots of setTintervals
everywhere.

Reacitiviy.js provides a better way, where functions themselves can notify when their value changes.

## Solution

Reactivity has a subscribe function that works just like the `on_change` function above

`reactivity.subscribe( function_to_watch, callback )`

where `function_to_watch` is a regular javascript function and callback is a function of the form:
`func(error, result)` ( this is the Node.js standard way of defining callbacks )


```javascript

reactivity.subscribe( getTime, function( err, res ){
  $('p').text( res )
})

```

This will work as long as whoever created `getTime` was kind enough to let us know "when" the value
of the function changes.


```javascript
function getTime(){
  var notifier = reactivity.notifier()  // request a notifier
  setTimeout( notifier, 1000 ) // call it in 1000MS
  return new Date().getTime()
}
```

In a very basic sense, Reactivity hast two parts:

* Publish ( use reactivity.notifier() )
* Consumer ( use reactivity.subscribe() )

We say that a function is reactive if it can notify us when its value has changed.
( somebody was kind enough to create a reactivity.notifier() under the covers )


### Transitivity

Reactivity is transitive. This means that any function consuming a reactive function becomes
reactive itself. For example:

```javascript

function getTimeWithMessage(){
  return "The current time is :" + getTime()
}


reactivity.subscribe( getTimeWithMessage, function( err, res ){
  $('p').text( res )
})


```

Or even


```javascript

function getTimeWithMessage(){
  return "The current time is :" + getTime()
}

function getTimeWithMessageUC(){
  return getTimeWithMessage().toUpperCase()
}

reactivity.subscribe( getTimeWithMessageUC, function( err, res ){
  $('p').text( res )
})


```

# Installation

## NPM

```shell
npm install reactivity
```

```javascript
var reactivity = require('reactivity')
```

## Browser

Include the following JS file ( you can find it in /build/... )

```html
<script src="reactivity.min.js"></script>
```

In the browser, the global reactivity object is attached to the root scope ( window )

```javascript
var reactivity = window.reactivity
```

If the object is already present then the library won't mess things up.
It will proxy calls to the pre-existing implementation.

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
The value of any specific function is not important.
What's important is the result of evaluating the complete expression.

## Where does this idea come from?

Like all good ideas and patterns in software they have been discovered and rediscovered over and over again.
Using a global object to allow producers talk to consumers up on the stack is common when invalidating
database caches for example.

Lately it has popped up in several frameworks ( like Meteor.js ). However, the pattern is usually tightly coupled with the host program/framework.
Reactivity.io decouples it and allows us to create interoperable reactive libraries.


