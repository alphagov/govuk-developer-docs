!function(t){"use strict";var e=t.GOVUK||{};e.Modules=e.Modules||{},e.modules={find:function(t){t=t||document;var e;e=t.querySelectorAll("[data-module]");for(var n=[],o=0;o<e.length;o++)n.push(e[o]);return t!==document&&t.getAttribute("data-module")&&n.push(t),n},start:function(t){function n(t){return a(o(t))}function o(t){return t.replace(/-([a-z])/g,function(t){return t.charAt(1).toUpperCase()})}function a(t){return t.charAt(0).toUpperCase()+t.slice(1)}for(var r=this.find(t),i=0,d=r.length;i<d;i++)for(var u=r[i],l=u.getAttribute("data-module").split(" "),s=0,c=l.length;s<c;s++){var f=n(l[s]),w=u.getAttribute("data-"+l[s]+"-module-started");if("function"==typeof e.Modules[f]&&!w)try{if(e.Modules[f].prototype.init)new e.Modules[f](u).init();else{var p=new e.Modules[f](u);p.start&&p.start($(u))}u.setAttribute("data-"+l[s]+"-module-started",!0)}catch(t){console.error("Error starting "+f+" component JS: ",t,window.location)}}}},t.GOVUK=e}(window),$(document).ready(function(){window.GOVUK.analyticsGa4=window.GOVUK.analyticsGa4||{},"undefined"!=typeof window.GOVUK.loadAnalytics&&(window.GOVUK.loadAnalytics.loadExtraDomains(),"undefined"==typeof window.GOVUK.analyticsGa4.vars&&window.GOVUK.loadAnalytics.loadGa4())});