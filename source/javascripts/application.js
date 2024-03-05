//= require govuk_tech_docs
//= require govuk_publishing_components/dependencies
//= require govuk_publishing_components/lib/trigger-event
//= require govuk_publishing_components/lib/cookie-functions
//= require govuk_publishing_components/lib/cookie-settings
//= require govuk_publishing_components/components/cookie-banner
//= require govuk_publishing_components/components/tabs
//= require govuk_publishing_components/load-analytics
//= require filter-list

// reworked version of modules.js from govuk_publishing_components
// needed to manually start tech docs gem modules now that we're including
// the modules code from govuk_publishing_components
var devdocsModulesFind = function () {
  container = document

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
}

var devdocsModulesStart = function () {
  var GOVUK = window.GOVUK
  var modules = devdocsModulesFind()

  for (var i = 0, l = modules.length; i < l; i++) {
    var element = modules[i]
    var moduleNames = element.getAttribute('data-module').split(' ')

    for (var j = 0, k = moduleNames.length; j < k; j++) {
      var moduleName = camelCaseAndCapitalise(moduleNames[j])
      var started = element.getAttribute('data-' + moduleNames[j] + '-module-started')
      if (typeof GOVUK.Modules[moduleName] === 'function' && !started) {
        try {
          var module = new GOVUK.Modules[moduleName]
          module.start($(element))
          element.setAttribute('data-' + moduleNames[j] + '-module-started', true)
        } catch (e) {
          // if there's a problem with the module, catch the error to allow other modules to start
          console.error('Error starting ' + moduleName + ' component JS: ' + e.message, window.location)
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

$(document).ready(function() {
  devdocsModulesStart()
})
