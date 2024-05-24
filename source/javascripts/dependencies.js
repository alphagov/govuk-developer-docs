// this is a copy of the dependencies.js from the gem
// replacing the call to modules.start with the dev docs custom version

// This adds in javascript that initialises components and dependencies
// that are provided by Slimmer in public frontend applications.
//= require ./modules.js

document.addEventListener('DOMContentLoaded', function () {
  window.GOVUK.analyticsGa4 = window.GOVUK.analyticsGa4 || {}
  window.GOVUK.analyticsVars = window.GOVUK.analyticsVars || {}

  // if statements ensure these functions don't execute during testing
  if (typeof window.GOVUK.loadAnalytics !== 'undefined') {
    window.GOVUK.loadAnalytics.loadExtraDomains()
    if (typeof window.GOVUK.analyticsGa4.vars === 'undefined') {
      window.GOVUK.loadAnalytics.loadGa4()
    }
    if (typeof window.GOVUK.analyticsVars.gaProperty === 'undefined') {
      window.GOVUK.loadAnalytics.loadUa()
    }
  }
})
