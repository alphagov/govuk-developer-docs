(function($) {
  function trackLinkClick(action, $element) {
    var linkText = $.trim($element.text());
    var linkURL = $element.attr('href');
    var label = linkText + '|' + linkURL;

    ga(
      'send',
      'event',
      'SM Technical Documentation', // Event Category
      action, // Event Action
      label // Event Label
    );
  }

  function linkTrackingEventHandler(action) {
    return function() {
      trackLinkClick(action, $(this));
    };
  };

  $(document).on('ready', function() {
    if (typeof ga === 'undefined') {
      return;
    }

    $('.technical-documentation a').on('click', linkTrackingEventHandler('inTextClick'));
    $('.header a').on('click', linkTrackingEventHandler('topNavigationClick'));
    $('.toc a').on('click', linkTrackingEventHandler('tableOfContentsNavigationClick'));
  });
})(jQuery);
