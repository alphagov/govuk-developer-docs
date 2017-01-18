(function($, Modules) {
  'use strict';

  Modules.InPageNavigation = function InPageNavigation() {
    var $tocPane;
    var $contentPane;
    var $tocItems;

    this.start = function start($element) {
      $tocPane = $element.find('.app-pane__toc');
      $contentPane = $element.find('.app-pane__content');
      $tocItems = $tocPane.find('a');

      $contentPane.on('scroll', _.debounce(handleScrollEvent, 250, { maxWait: 250 }));

      if (Modernizr.history) {
        // Popstate is triggered when using the back button to navigate 'within'
        // the page, i.e. changing the anchor part of the URL.
        $(window).on('popstate', function (event) {
          restoreScrollPosition(event.originalEvent.state);
        });

        if (history.state && history.state.scrollTop) {
          // Restore existing state when e.g. using the back button to return to
          // this page
          restoreScrollPosition(history.state);
        } else {
          // Store initial position so we can restore it when using back button
          handleScrollEvent();
        }
      }
    };

    function restoreScrollPosition(state) {
      if (state && typeof state.scrollTop !== 'undefined') {
        $contentPane.scrollTop(state.scrollTop);
      }
    }

    function handleScrollEvent() {
      var $activeTocItem = tocItemForFirstElementInView();

      storeCurrentPositionInHistoryApi($activeTocItem);
      highlightActiveItemInToc($activeTocItem);
    }

    function storeCurrentPositionInHistoryApi($activeTocItem) {
      if (Modernizr.history) {
        history.replaceState(
          { scrollTop: $contentPane.scrollTop() },
          "",
          $activeTocItem.attr('href')
        );
      }
    }

    function highlightActiveItemInToc($activeTocItem) {
      $tocItems.removeClass('toc-link--in-view');

      if ($activeTocItem) {
        $activeTocItem.addClass('toc-link--in-view');
      }
    }

    function tocItemForFirstElementInView() {
      var target = null;

      $($tocItems.get().reverse()).each(function checkIfInView(index) {
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
