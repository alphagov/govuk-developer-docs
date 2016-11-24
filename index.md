---
layout: main
title: Dashboard
navigation_weight: 1
source_url: https://github.com/alphagov/govuk-developers/blob/master/_config/dashboard.yml
edit_url: https://github.com/alphagov/govuk-developers/edit/master/_config/dashboard.yml
permalink: index.html
---

<div class="app-pane__toc">
  <nav class="toc">
    <ul>
      {% for column in site.data.content %}
        <li>
          <a href='#{{ column.id }}'>{{ column.name }}</a>
          <ul>
            {% for section in column.sections %}
              <li>
                <a href='#{{ section.id }}'>{{ section.name }}</a>
              </li>
            {% endfor %}
          </ul>
        </li>
      {% endfor %}
    </ul>
  </nav>
</div>

<div class="app-pane__content">
  <div id="content" class="technical-documentation">
    <h1 class="page-title">{{ page.title }}</h1>

    {% for column in site.data.content %}
      <h2 id='{{ column.id }}'>{{ column.name }}</h2>

      {% for section in column.sections %}
        <h3 id='{{ section.id }}'>{{ section.name }}</h3>

        {% for entry in section.entries %}
          <div class='entry'>
            <a href='{{ entry.url }}'>{{ entry.name }}</a>
            <small>{{ entry.description }}</small>
          </div>
        {% endfor %}
      {% endfor %}
    {% endfor %}
  </div>
</div>
