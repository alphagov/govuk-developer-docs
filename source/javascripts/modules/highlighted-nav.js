(function($, Modules) {
  'use strict';

  Modules.HighlightedNav = function HighlightedNav() {
    var $tocPane;
    var $contentPane;

    this.start = function start($element) {
      $tocPane = $element.find('.app-pane__toc');
      $contentPane = $element.find('.app-pane__content');
      $contentPane.on('scroll', handleScroll);
      handleScroll();
    };

    function handleScroll() {
      var $anchors = $tocPane.find('a');
      var inView = firstElementInView($anchors);

      $anchors.removeClass('toc-link--in-view');

      if (!inView) {
        return;
      }

      inView.addClass('toc-link--in-view')
    }

    function firstElementInView($anchors) {
      var target = null;

      $($anchors.get().reverse()).each(function checkIfInView(index) {
        if (target) {
          return;
        }

        var $this = $(this);
        var $heading = $contentPane.find($this.attr('href'));

        if ($heading.position().top <= 0) {
          target = $this;
        }
      });

      return target;
    }
  };
})(jQuery, window.GOVUK.Modules);
