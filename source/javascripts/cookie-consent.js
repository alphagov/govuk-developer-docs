window.GOVUK = window.GOVUK || {}

window.GOVUK.gtm = {
  init: function () {
    this.consent = false;
    window.dataLayer = window.dataLayer || [];
    this.gtag();
    this.checkConsent();
    this.cookieForm = document.querySelector('[data-module="cookie-settings"]');
    if (this.cookieForm) {
      this.setupCookieForm();
    }
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
    var cookies = document.cookie;
    cookies = cookies.split(';');

    for (var i = 0; i < cookies.length; i++) {
      var thisCookie = cookies[i].split('=');
      if (thisCookie[0] == 'analytics_consent') {
        // consent cookie exists and is yes, init gtm
        // if it exists and is no, we just hide the banner
        if (thisCookie[1] == 'true') {
          this.consent = true;
          this.setupGtm();
        }
        this.hideCookieBanner();
        break;
      }
    }
  },

  denyCookies: function () {
    this.consent = false;
    this.gtag('consent', 'default', {
      'ad_storage': 'denied'
    });
    this.cookieConsent();
    this.hideCookieBanner();
  },

  acceptCookies: function () {
    this.consent = true;
    this.gtag('consent', 'update', {
      'ad_storage': 'granted'
    });
    this.setupGtm();
    this.cookieConsent();
    this.hideCookieBanner();
  },

  cookieConsent: function () {
    var consentCookie = "analytics_consent=" + this.consent + "; Secure;"
    var date = new Date()
    date.setTime(date.getTime() + (365 * 24 * 60 * 60 * 1000)); // expire a year from now
    consentCookie = consentCookie + '; expires=' + date.toGMTString();
    this.writeCookies(consentCookie + document.cookie);
  },

  hideCookieBanner: function () {
    var banner = document.getElementById('cookiebanner');
    banner.style.display = 'none';
  },

  writeCookies: function (cookies) {
    document.cookie = cookies;
  },

  setupCookieForm: function () {
    this.setCookiePageOption();
    this.cookieForm.addEventListener('submit', function (e) {
      e.preventDefault();
      var consent = document.querySelector('input[name="cookie-consent"]:checked').value;
      if (consent == 'true') {
        this.acceptCookies();
      } else {
        this.denyCookies();
      }
      document.getElementById('cookie-page-notice').style.display = 'block';
      // this.cookieForm.submit();
    }.bind(this));
  },

  setCookiePageOption: function () {
    if (this.consent) {
      document.getElementById('cookie-consent-0').checked = true;
    } else {
      document.getElementById('cookie-consent-1').checked = true;
    }
  }
}

window.addEventListener("DOMContentLoaded", function(event) {
  window.GOVUK.gtm.init();
});
