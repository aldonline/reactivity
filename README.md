# reactivity.js

The Canonical Implementation of the Native Reactivity pattern for Javascript

## What is Native Reactivity?

Native Reactivity is a technique that has been used by several UI frameworks ( Meteor being perhaps the most visible ) that allows for transparent propagation of changes to the UI.

This technique does not require explicitly defining dependencies between pieces of your code, funcions and the UI. Changes propagate automatically.

How?

Here's how:



## Example

( Take a look at `/examples` )

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

reactiviy.js provides a better way, where functions themselves can notify when their value changes.

## Solution

reactivity.js has a subscribe function that works just like the `on_change` function above

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

OK. You're probably thinking: "Why go through all this if I could probably write somehing like that myself".
Well, there are several things that reactivity.js gives you that would be really hard to implement yourself:

* 100% transparent transitivity ( aka dependency tracking, dataflow, etc )
* Transparent interoperation with other reactive libraries. For example:
 * [Syncify](https://github.com/aldonline/syncify): A clever way to get rid of callbacks / asynchronicity )
 * [Reactive Router](https://github.com/aldonline/reactive_router)

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

The official API documentation is the [TypeScript Definition file](https://github.com/aldonline/reactivity/blob/master/reactivity.d.ts).
( TODO: someone please generate docs from the d.ts file )


# FAQ

## Why do we need a "Standard" library?

In order to combine reactive libraries developed by different people at different
times we need a standard implementation.

Why?

Because of the way reactivity events are propagated you need to share some assumptions.
If everyone uses this library as a foundation and those assumptions are met then you can combine
reactive functions from different libraries transparently.

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
reactivity.js decouples it and allows us to create interoperable reactive libraries.


