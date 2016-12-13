(function($, Modules) {
  'use strict';

  Modules.TableOfContents = function () {
    var $html = $('html');
    var $toc;

    this.start = function ($element) {
      var $closeLink = $element.find('.js-toc-close');
      var $tocList = $element.find('.js-toc-list');

      $toc = $element;

      fixRubberBandingInIOS();

      // Need delegated handler for show link as sticky polyfill recreates element
      $html.on('click.toc', '.js-toc-show', preventingScrolling(openNavigation));
      $closeLink.on('click.toc', preventingScrolling(closeNavigation));
      $tocList.on('click.toc', 'a', closeNavigation);
    };

    function fixRubberBandingInIOS() {
      // By default when the table of contents is at the top or bottom,
      // scrolling in that direction will scroll the body 'behind' the table of
      // contents. Fix this by preventing ever reaching the top or bottom of the
      // table of contents (by 1 pixel).
      // 
      // http://blog.christoffer.me/six-things-i-learnt-about-ios-safaris-rubber-band-scrolling/
      $toc.on("touchstart.toc", function () {
        var $this = $(this),
          top = $this.scrollTop(),
          totalScroll = $this.prop('scrollHeight'),
          currentScroll = top + $this.prop('offsetHeight');

        if (top === 0) {
          $this.scrollTop(1);
        } else if (currentScroll === totalScroll) {
          $this.scrollTop(top - 1);
        }
      });
    }

    function openNavigation() {
      $html.addClass('toc-open');
    }

    function closeNavigation() {
      $html.removeClass('toc-open');
    }

    function preventingScrolling(callback) {
      return function (event) {
        event.preventDefault();
        callback();
      }
    }
  };
})(jQuery, window.GOVUK.Modules);
