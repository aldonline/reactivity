# reactivity.js

The Unofficially Official Native Reactivity API for Javascript.
Work with reactive streams of data using pure Javascript expressions.

## The simple explanation:

* `reactivity.js` allows you to create special ( reactive ) javascript functions that auto-update when their value changes. It is highly convenient and transparent. There is no need to configure anything. Most people use it to bind data to a UI, for example. 
* `reactivity.js` knows how to deal with asynchronous code so that you don't have to worry about callbacks.

## A more advanced explanation

`reactivity.js` is a cannonical implementation of the [Native Reactivity](https://github.com/aldonline/reactivity/wiki/Native-Reactivity) pattern. It exposes reactive streams of data as pure javascript expressions.
Additionally, in order to reconcile sync and async datasources, `reactivity.js` integrates [Forced Execution Suspension](https://github.com/aldonline/reactivity/wiki/Forced-Execution-Suspension) and [Stateful Service Lifecycle Management](https://github.com/aldonline/reactivity/wiki/Stateful-Service-Lifecycle-Management).
The end result is a pure javascript environment where you can transparently mix and match expressions that are reactive, non-reactive, synchronous or asynchronous!

You can essentially represent ANY expression that returns data as a reactive expression.

No more [DonkeyScript](https://www.donkeyscript.org/)!


## Can you show me some examples?

Sure. Here's an example that will print out the time every second:

```javascript
reactivity.react(function(){
  console.log("The current time is " + getTime() )
})
```

The getTime() function is a `reactive expression`. It returns a value just like a regular function, but it also emits an event whenever its value changes. The reactivity.react() function knows how to listen for these events and as soon as they occurr it will re-evaluate whatever it contains.

In order for this to work, the `getTime()` function must `notify` that its value has changed.

... TODO

# Overview

In a very basic sense, Reactivity hast two parts:

* Publish ( use reactivity.notifier() )
* Consumer ( use reactivity.react() )

We say that a function is reactive if it can notify us when its value has changed.
( somebody was kind enough to create a reactivity.notifier() under the covers )

OK. You're probably thinking: "Why go through all this if I could probably write somehing like that myself".
Well, there are several things that reactivity.js gives you that would be really hard to implement yourself:

* 100% transparent transitivity ( aka dependency tracking, dataflow, etc )
* Transparent interoperation with other reactive libraries. For example:
 * [Syncify](https://github.com/aldonline/syncify): A clever way to get rid of callbacks / asynchronicity
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


