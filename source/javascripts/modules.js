// reworked version of modules.js from govuk_publishing_components to support jQuery
;(function (global) {
  'use strict'

  var GOVUK = global.GOVUK || {}
  GOVUK.Modules = GOVUK.Modules || {}

  GOVUK.modules = {
    find: function (container) {
      container = container || document

      var modules
      var moduleSelector = '[data-module]'

      modules = container.querySelectorAll(moduleSelector)
      var modulesArray = []
      // convert nodelist of modules to array
      for (var i = 0; i < modules.length; i++) {
        modulesArray.push(modules[i])
      }

      // Container could be a module too
      if (container !== document && container.getAttribute('data-module')) {
        modulesArray.push(container)
      }
      return modulesArray
    },

    start: function (container) {
      var modules = this.find(container)

      for (var i = 0, l = modules.length; i < l; i++) {
        var element = modules[i]
        var moduleNames = element.getAttribute('data-module').split(' ')

        for (var j = 0, k = moduleNames.length; j < k; j++) {
          var moduleName = camelCaseAndCapitalise(moduleNames[j])
          var started = element.getAttribute('data-' + moduleNames[j] + '-module-started')
          if (typeof GOVUK.Modules[moduleName] === 'function' && !started) {
            try {
              if (GOVUK.Modules[moduleName].prototype.init) {
                // Vanilla JavaScript GOV.UK Modules and GOV.UK Frontend V4 Modules
                new GOVUK.Modules[moduleName](element).init()
              } else {
                // GOV.UK Frontend V5 Modules - removed component init() methods and initialise in constructor
                // https://github.com/alphagov/govuk-design-system-architecture/blob/main/decision-records/010-remove-init-method.md
                /* eslint-disable no-new */
                var module = new GOVUK.Modules[moduleName](element)

                // Support jQuery modules
                // https://github.com/alphagov/govuk_publishing_components/blob/main/docs/javascript-modules.md
                if (module.start) {
                  module.start($(element))
                }
              }
              element.setAttribute('data-' + moduleNames[j] + '-module-started', true)
            } catch (e) {
              // if there's a problem with the module, catch the error to allow other modules to start
              console.error('Error starting ' + moduleName + ' component JS: ', e, window.location)
            }
          }
        }
      }

      // eg selectable-table to SelectableTable
      function camelCaseAndCapitalise (string) {
        return capitaliseFirstLetter(camelCase(string))
      }

      // http://stackoverflow.com/questions/6660977/convert-hyphens-to-camel-case-camelcase
      function camelCase (string) {
        return string.replace(/-([a-z])/g, function (g) {
          return g.charAt(1).toUpperCase()
        })
      }

      // http://stackoverflow.com/questions/1026069/capitalize-the-first-letter-of-string-in-javascript
      function capitaliseFirstLetter (string) {
        return string.charAt(0).toUpperCase() + string.slice(1)
      }
    }
  }

  global.GOVUK = GOVUK
})(window)
