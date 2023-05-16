window.GOVUK = window.GOVUK || {}

window.GOVUK.gtm = {
  init: function () {
    window.dataLayer = window.dataLayer || [];
    this.gtag();
    this.checkConsent();
  },

  gtag: function () {
    dataLayer.push(arguments);
  },

  setupGtm: function () {
    (function(w,d,s,l,i){w[l]=w[l]||[];w[l].push({'gtm.start':
    new Date().getTime(),event:'gtm.js'});var f=d.getElementsByTagName(s)[0],
    j=d.createElement(s),dl=l!='dataLayer'?'&l='+l:'';j.async=true;j.src=
    'https://www.googletagmanager.com/gtm.js?id='+i+dl;f.parentNode.insertBefore(j,f);
    })(window,document,'script','dataLayer','GTM-TNKCK97');      
  },

  checkConsent: function () {
    var cookies = this.readCookies();
    cookies = cookies.split(';');

    for (var i = 0; i < cookies.length; i++) {
      var thisCookie = cookies[i].split('=');
      if (thisCookie[0] == 'analytics_consent') {
        // consent cookie exists and is yes, init gtm
        // if it exists and is no, we just hide the banner
        if (thisCookie[1] == 'true') {
          this.setupGtm();
        }
        this.hideCookieBanner();
        break;
      }
    }
  },

  denyCookies: function () {
    this.gtag('consent', 'default', {
      'ad_storage': 'denied'
    });
    this.cookieConsent("false");
    this.hideCookieBanner();
  },

  acceptCookies: function () {
    this.gtag('consent', 'update', {
      'ad_storage': 'granted'
    });
    this.setupGtm();
    this.cookieConsent("true");
    this.hideCookieBanner();
  },

  cookieConsent: function (trueOrFalse) {
    var consentCookie = "analytics_consent=" + trueOrFalse + "; Secure" + this.readCookies();
    this.writeCookies(consentCookie);
  },

  hideCookieBanner: function () {
    var banner = document.getElementById('cookiebanner');
    banner.style.display = 'none';
  },

  readCookies: function () {
    return document.cookie;
  },

  writeCookies: function (cookies) {
    document.cookie = cookies;
  }
}

window.addEventListener("DOMContentLoaded", function(event) {
  window.GOVUK.gtm.init();
});
