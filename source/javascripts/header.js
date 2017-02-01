(function(){
  function addEventListener(el, eventName, handler) {
    if (el.addEventListener) {
      el.addEventListener(eventName, handler);
    } else {
      el.attachEvent('on' + eventName, function(){
        handler.call(el);
      });
    }
  }

  var navToggle = document.getElementById('show-menu');
  var nav = document.getElementById('navigation');

  addEventListener(navToggle, 'change', function () {
    var navIsVisible = navToggle.checked;

    navToggle.setAttribute('aria-expanded', (navIsVisible ? 'true' : 'false'));
    nav.setAttribute('aria-hidden', (navIsVisible ? 'false' : 'true'));
  });  
}());
