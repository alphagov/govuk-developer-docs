(function($, Modules) {
  'use strict';

  Modules.InPageNavigation = function InPageNavigation() {
    var $tocPane;
    var $contentPane;
    var $tocItems;

    this.start = function start($element) {
      $tocPane = $element.find('.app-pane__toc');
      $contentPane = $element.find('.app-pane__content');
      $tocItems = $('.js-toc-list').find('a');

      $contentPane.on('scroll', _.debounce(handleScrollEvent, 100, { maxWait: 100 }));

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
          // Store the initial position so that we can restore it even if we
          // never scroll.
          handleInitialLoadEvent();
        }
      }
    };

    function restoreScrollPosition(state) {
      if (state && typeof state.scrollTop !== 'undefined') {
        $contentPane.scrollTop(state.scrollTop);
      }
    }

    function handleInitialLoadEvent() {
      var $activeTocItem = tocItemForTargetElement();

      if ($activeTocItem.length == 0) {
        $activeTocItem = tocItemForFirstElementInView();
      }

      handleChangeInActiveItem($activeTocItem);
    }

    function handleScrollEvent() {
      handleChangeInActiveItem(tocItemForFirstElementInView());
    }

    function handleChangeInActiveItem($activeTocItem) {
      storeCurrentPositionInHistoryApi($activeTocItem);
      highlightActiveItemInToc($activeTocItem);
    }

    function storeCurrentPositionInHistoryApi($activeTocItem) {
      if (Modernizr.history && $activeTocItem && $activeTocItem.length == 1) {
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
        scrollTocToActiveItem($activeTocItem);
      }
    }

    function scrollTocToActiveItem($activeTocItem) {
      var paneHeight = $tocPane.height();
      var linkTop = $activeTocItem.position().top;
      var linkBottom = linkTop + $activeTocItem.outerHeight();

      var offset = null;

      if (linkTop < 0) {
        offset = linkTop;
      } else if (linkBottom >= paneHeight) {
        offset = -(paneHeight - linkBottom);
      } else {
        return;
      }

      var newScrollTop = $tocPane.scrollTop() + offset;

      $tocPane.scrollTop(newScrollTop);
    }

    function tocItemForTargetElement() {
      var target = window.location.hash
      var $targetElement = $(target);

      if ($targetElement) {
        return $tocItems.filter(function (elem) {
          return ($(this).attr('href') == target);
        }).first();
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
