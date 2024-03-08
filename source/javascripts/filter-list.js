window.GOVUK = window.GOVUK || {}
window.GOVUK.Modules = window.GOVUK.Modules || {};

(function (Modules) {
  function FilterList ($module) {
    this.$module = $module
  }

  FilterList.prototype.init = function () {
    // find the input element
    this.$module.input = this.$module.nodeName === 'INPUT' ? this.$module : this.$module.querySelector('input')
    if (!this.$module.input) {
      return
    }
    this.$module.form = this.$module.input.closest('form')
    if (this.$module.form) {
      this.$module.form.addEventListener('submit', function (e) { e.preventDefault() })
    }

    this.$module.input.addEventListener('input', function () {
      var searchTerm = this.$module.input.value
      this.filterList(searchTerm)
    }.bind(this))
  }

  FilterList.prototype.filterList = function (searchTerm) {
    var itemsToFilter = document.querySelectorAll('[data-filter-section]')

    for (var i = 0; i < itemsToFilter.length; i++) {
      var current = itemsToFilter[i]
      var title = current.querySelector('[data-filter-title]')
      var children = current.querySelectorAll('[data-filter-item]')
      if (title && children) {
        // show/hide children
        for (var j = 0; j < children.length; j++) {
          var child = children[j]
          var text = child.textContent.toLowerCase()
          this.showHide(text, searchTerm, child)
        }
        // show/hide title
        if (current.querySelectorAll('.filter-list-hidden[data-filter-item]').length === children.length) {
          title.classList.add('filter-list-hidden')
        } else {
          title.classList.remove('filter-list-hidden')
        }
      } else {
        var text = current.textContent.toLowerCase()
        this.showHide(text, searchTerm, current)
      }
    }
  }

  FilterList.prototype.showHide = function (text, searchTerm, element) {
    if (text.includes(searchTerm.toLowerCase())) {
      element.classList.remove('filter-list-hidden')
    } else {
      element.classList.add('filter-list-hidden')
    }
  }

  Modules.FilterList = FilterList
})(window.GOVUK.Modules)
