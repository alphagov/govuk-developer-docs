---
owner_slack: "#govuk-frontenders"
title: How to remove jQuery from JavaScript
section: Frontend
layout: manual_layout
parent: "/manual.html"
related_repos:
 - govuk_publishing_components
---

GOV.UK has a dependency on jQuery 1.12.4. This is an old and unsupported version and we are trying to remove it.

This is a guide to removing jQuery from JavaScript (JS). First read the documentation for our [JS modules](https://github.com/alphagov/govuk_publishing_components/blob/master/docs/javascript-modules.md).

## General advice

Modules are passed an element to act on. When that changes from a jQuery object to a JS node, all of the rest of the code is likely to error. This means that most tasks to remove jQuery from our modules cannot be done in small (easily reviewable) commits.

All of our JS modules are started centrally by `modules.js` in the components gem. That means you don’t need to worry about manually calling a bit of JS to make a module run - if an element on a page has a `data-module="name-of-module"` attribute, it’ll get started. However if the code wasn’t a module to begin with, it may be manually started somewhere in the application, and this will need to be removed.

## Rewriting tests

We use Jasmine for testing our JS and our tests often use jQuery. Jasmine includes its own copy of jQuery which isn’t included in the public site, so jQuery does not have to be removed from tests. However some rewriting is necessary, for example:

- module initialisation inside the tests will need to change from `start` to `init` (see below)
- elements passed to the module from the test will need to be JS nodes, not jQuery elements. This can be achieved by changing e.g. `$('.element')` to `$('.element')[0]`

In many tests the module is kept as a variable in order to check things, this may need to be restructured.

```javascript
// jQuery (old)
var module = new GOVUK.Modules.nameOfModule.start(jQueryElement)
module.aFunction()

// JS (new)
var module = new GOVUK.Modules.nameOfModule(jsElement)
module.init()
module.aFunction()
```

If the module code is not called again, this can be written more simply as:

```javascript
new GOVUK.Modules.nameOfModule.start(jQueryElement) // jQuery (old)
new GOVUK.Modules.nameOfModule(jsElement).init() // JS (new)
```

## Resources

- [youmightnotneedjquery.com](http://youmightnotneedjquery.com/)
- the `#govuk-frontenders` or `#frontend` slack channels

## Common problems

### jQuery objects are different from JS nodes

Using jQuery to find an element returns a jQuery object that can have jQuery functions applied to it e.g.

```javascript
var jqExample = $('div')
jqExample.addClass('test')
```

Using JS to find an element returns a node, which can have JS functions applied to it e.g.

```javascript
var jsExample = document.querySelector('div')
jsExample.addClass('test') // errors
jsExample.classList.add('test') // works
```

`jqExample` and `jsExample` are incompatible. jQuery functions cannot be applied to the JS node and vice versa.

The jQuery object contains a JS node, accessed as `jqExample[0]`. Note that `jqExample` is not an iterable array.

### Things where jQuery and JS use the same function name

Some jQuery functions are named the same as their equivalent JS function, for example:

- `click()`
- `focus()`
- `closest()`

This is confusing, because the code chooses the right one to use based on what kind of object it’s being run on.

```javascript
$('button').click() // calls the jQuery function
document.querySelector('button').click() // calls the JS
```

Note that some of these may behave slightly differently, particularly in what they return.

### jQuery is more forgiving than JS

The result of jQuery’s find function might not find anything, but it will still return an empty jQuery object. Subsequent actions on that object (e.g. adding a class) might not do anything but they won’t cause an error.

Attempting the same thing with JS and `querySelector` will return `null` if no matching element is found, which means any attempt to do anything with that result will cause an error.

This means more checks may have to be added to the code.

```javascript
var example = document.querySelector('.this')
if (example) {
  // do something
}

var example2 = document.querySelectorAll('.that')
if (example2.length) {
  // do something
}
```

### When to use querySelector and querySelectorAll

In jQuery an element can be found on the page using `.find()`. There are two equivalent functions in JS.

- [querySelector](https://developer.mozilla.org/en-US/docs/Web/API/Document/querySelector) finds only the first element that matches the given query.
- [querySelectorAll](https://developer.mozilla.org/en-US/docs/Web/API/Document/querySelectorAll) finds all elements that match that query, and returns a non-live NodeList (which in most instances can be treated as an array)

The code should suggest which should be used:

- if the result of `find` is used in a loop, or an each, use `querySelectorAll`
- if `find` is used for an id e.g. `.find('#wrapper')`, `use querySelector`
- otherwise, look for clues - count the instances of elements that would match in the markup, is the variable name plural or singular?

### Setting and getting attributes

jQuery uses the same function to both read and set attributes on elements.

```javascript
var element = $('.element')
element.attr('class') // reads attribute
element.attr('class', 'something') // sets attribute
```

In JavaScript these are different functions.

```javascript
var element = document.querySelector('.element')
element.getAttribute('class') // reads attribute
element.setAttribute('class', 'something') // sets attribute
```

jQuery also has a single function for reading and setting `data-` attributes on elements.

```javascript
var element = $('.element')
element.data('module') // reads the data-module attribute
element.data('module', 'something') // sets the data-module attribute
```

JavaScript uses the same functions as before for the equivalent action.

```javascript
var element = document.querySelector('.element')
element.getAttribute('data-module') // reads attribute
element.setAttribute('data-module', 'something') // sets attribute
```

### Chaining functions

jQuery’s strength lies in combining multiple statements that act on multiple elements into single lines.

```javascript
$('div').addClass('test').data('item', 'value').hide()
```

JS is a bit more verbose. The equivalent would be:

```javascript
var divs = document.querySelectorAll('div')

for (var i = 0; i < divs.length; i++) {
  var div = divs[i]
  div.classList.add('test')
  div.setAttribute('data-item', 'value')
  div.style.display = 'none'
}
```

### Adding event listeners

jQuery’s event listeners are simple to add and can be applied to multiple elements at once.

```javascript
element.find('a').on('click', function () {} )
```

Doing the same thing in JS is a bit more complicated as event listeners can’t be attached to a group of elements in quite the same way. This is one possibility:

```javascript
var links = document.querySelectorAll('a')
links.addEventlistener('click', function() { }) // won't work

// will work
for (var i = 0; i < links.length; i++) {
  links[i].addEventListener('click', function () {})
}
```

The above is a bit verbose and can potentially add a lot of event listeners. It might be better to attach a single event listener to an element higher in the DOM tree and listen for specific element interactions, as events will 'bubble' up through the DOM.

```javascript
var component = document.querySelector('.component')

component.addEventListener('click', function (e) {
  var clicked = e.target
  // check for class name or element type and do something
})
```

### Events don’t fire properly in tests

If a test triggers an event on an element that is a jQuery object, this might not cause an eventListener on a JS node to fire.

Tests that fire events may need to be converted as follows.

```javascript
$('.link').click() // from this
$('link')[0].click() // to this
```

On GOV.UK, you can also use the `triggerEvent` script from the components gem for less common events. This can also help with older browser compatibility problems.

```javascript
// window.GOVUK.triggerEvent(element, eventType, options)
window.GOVUK.triggerEvent(element, 'keyup', { keyCode: 13 })
```
