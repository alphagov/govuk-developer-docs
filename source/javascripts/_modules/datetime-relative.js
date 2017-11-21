(function ($, Modules) {
  'use strict'
  Modules.DatetimeRelative = function () {
    this.start = function ($element) {
      var originalText = $element.text().trim()
      var suffix = originalText ? ' (' + originalText + ')' : ''
      var dateTime = $element.attr('datetime')
      var timestamp = Date.parse(dateTime)
      if (isNaN(timestamp) === false) {
        $element.text(
          timeUntil(new Date(dateTime)) + suffix
        )
      }
    }

    // Forked from https://github.com/github/time-elements
    var timeUntil = function (date) {
      var ms = date.getTime() - new Date().getTime()

      var sec = Math.round(ms / 1000)
      var min = Math.round(sec / 60)
      var hr = Math.round(min / 60)
      var day = Math.round(hr / 24)
      var month = Math.round(day / 30)
      var year = Math.round(month / 12)

      if (month >= 18) {
        return year + ' years from now'
      } else if (month >= 12) {
        return 'a year from now'
      } else if (day >= 45) {
        return month + ' months from now'
      } else if (day >= 30) {
        return 'a month from now'
      } else if (hr >= 36) {
        return day + ' days from now'
      } else if (hr >= 24) {
        return 'a day from now'
      } else if (Math.abs(month) >= 45) {
        return Math.abs(month) + ' months ago'
      } else if (day < 0) {
        return Math.abs(day) + ' days ago'
      } else {
        return 'now'
      }
    }
  }
})(window.jQuery, window.GOVUK.Modules)
