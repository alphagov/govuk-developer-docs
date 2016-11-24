---
layout: default
title: Dictionary
navigation_weight: 16
permalink: dictionary.html
source_url: https://github.com/alphagov/govuk-developers/blob/master/_config/dictionary.yml
edit_url: https://github.com/alphagov/govuk-developers/edit/master/_config/dictionary.yml
---

(Originally from [the Wiki](https://gov-uk.atlassian.net/wiki/display/TECH/Publishing+Platform))

{% for word in site.data.dictionary %}
<div>
  <h2>{{word.word}}</h2>
  <small>Synonyms: {{word.synonyms}}</small>
  <p>{{word.description}}</p>
</div>
{% endfor %}

<img src='assets/images/words.png' style='width:100%'/>
