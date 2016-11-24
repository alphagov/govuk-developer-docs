---
layout: gem_layout
title: slimmer
---

## `class Slimmer::App`

### `#logger`

Returns the value of attribute logger

**See**:
- [Source on GitHub](https://github.com/alphagov/slimmer/blob/master/lib/slimmer/app.rb#L5)

### `#logger=(value)`

Sets the attribute logger

**Params**:

- `value` (``) — the value to set the attribute logger to.


**See**:
- [Source on GitHub](https://github.com/alphagov/slimmer/blob/master/lib/slimmer/app.rb#L5)

### `#initialize(app, *args, &block)`

**Returns**:

- (`App`) — a new instance of App

**See**:
- [Source on GitHub](https://github.com/alphagov/slimmer/blob/master/lib/slimmer/app.rb#L7)

### `#call(env)`


**See**:
- [Source on GitHub](https://github.com/alphagov/slimmer/blob/master/lib/slimmer/app.rb#L37)

### `#response_can_be_rewritten?(status, headers)`

**Returns**:

- (`Boolean`) —

**See**:
- [Source on GitHub](https://github.com/alphagov/slimmer/blob/master/lib/slimmer/app.rb#L52)

### `#skip_slimmer?(env, response)`

**Returns**:

- (`Boolean`) —

**See**:
- [Source on GitHub](https://github.com/alphagov/slimmer/blob/master/lib/slimmer/app.rb#L56)

### `#in_development?`

**Returns**:

- (`Boolean`) —

**See**:
- [Source on GitHub](https://github.com/alphagov/slimmer/blob/master/lib/slimmer/app.rb#L60)

### `#skip_slimmer_param?(env)`

**Returns**:

- (`Boolean`) —

**See**:
- [Source on GitHub](https://github.com/alphagov/slimmer/blob/master/lib/slimmer/app.rb#L64)

### `#skip_slimmer_header?(response)`

**Returns**:

- (`Boolean`) —

**See**:
- [Source on GitHub](https://github.com/alphagov/slimmer/blob/master/lib/slimmer/app.rb#L69)

### `#s(body)`


**See**:
- [Source on GitHub](https://github.com/alphagov/slimmer/blob/master/lib/slimmer/app.rb#L73)

### `#content_length(rewritten_body)`


**See**:
- [Source on GitHub](https://github.com/alphagov/slimmer/blob/master/lib/slimmer/app.rb#L80)

### `#rewrite_response(env, response)`


**See**:
- [Source on GitHub](https://github.com/alphagov/slimmer/blob/master/lib/slimmer/app.rb#L86)

### `#strip_slimmer_headers(headers)`


**See**:
- [Source on GitHub](https://github.com/alphagov/slimmer/blob/master/lib/slimmer/app.rb#L112)

---

## `class Slimmer::Skin`

### `#load_template(template_name)`


**See**:
- [Source on GitHub](https://github.com/alphagov/slimmer/blob/master/lib/slimmer/test.rb#L5)

### `#template_cache`

Returns the value of attribute template_cache

**See**:
- [Source on GitHub](https://github.com/alphagov/slimmer/blob/master/lib/slimmer/skin.rb#L6)

### `#template_cache=(value)`

Sets the attribute template_cache

**Params**:

- `value` (``) — the value to set the attribute template_cache to.


**See**:
- [Source on GitHub](https://github.com/alphagov/slimmer/blob/master/lib/slimmer/skin.rb#L6)

### `#asset_host`

Returns the value of attribute asset_host

**See**:
- [Source on GitHub](https://github.com/alphagov/slimmer/blob/master/lib/slimmer/skin.rb#L6)

### `#asset_host=(value)`

Sets the attribute asset_host

**Params**:

- `value` (``) — the value to set the attribute asset_host to.


**See**:
- [Source on GitHub](https://github.com/alphagov/slimmer/blob/master/lib/slimmer/skin.rb#L6)

### `#logger`

Returns the value of attribute logger

**See**:
- [Source on GitHub](https://github.com/alphagov/slimmer/blob/master/lib/slimmer/skin.rb#L6)

### `#logger=(value)`

Sets the attribute logger

**Params**:

- `value` (``) — the value to set the attribute logger to.


**See**:
- [Source on GitHub](https://github.com/alphagov/slimmer/blob/master/lib/slimmer/skin.rb#L6)

### `#strict`

Returns the value of attribute strict

**See**:
- [Source on GitHub](https://github.com/alphagov/slimmer/blob/master/lib/slimmer/skin.rb#L6)

### `#strict=(value)`

Sets the attribute strict

**Params**:

- `value` (``) — the value to set the attribute strict to.


**See**:
- [Source on GitHub](https://github.com/alphagov/slimmer/blob/master/lib/slimmer/skin.rb#L6)

### `#options`

Returns the value of attribute options

**See**:
- [Source on GitHub](https://github.com/alphagov/slimmer/blob/master/lib/slimmer/skin.rb#L6)

### `#options=(value)`

Sets the attribute options

**Params**:

- `value` (``) — the value to set the attribute options to.


**See**:
- [Source on GitHub](https://github.com/alphagov/slimmer/blob/master/lib/slimmer/skin.rb#L6)

### `#initialize options = {}`

**Returns**:

- (`Skin`) — a new instance of Skin

**See**:
- [Source on GitHub](https://github.com/alphagov/slimmer/blob/master/lib/slimmer/skin.rb#L8)

### `#template(template_name)`


**See**:
- [Source on GitHub](https://github.com/alphagov/slimmer/blob/master/lib/slimmer/skin.rb#L17)

### `#template_url(template_name)`


**See**:
- [Source on GitHub](https://github.com/alphagov/slimmer/blob/master/lib/slimmer/skin.rb#L35)

### `#report_parse_errors_if_strict!(nokogiri_doc, description_for_error_message)`


**See**:
- [Source on GitHub](https://github.com/alphagov/slimmer/blob/master/lib/slimmer/skin.rb#L41)

### `#parse_html(html, description_for_error_message)`


**See**:
- [Source on GitHub](https://github.com/alphagov/slimmer/blob/master/lib/slimmer/skin.rb#L45)

### `#context(html, error)`


**See**:
- [Source on GitHub](https://github.com/alphagov/slimmer/blob/master/lib/slimmer/skin.rb#L61)

### `#ignorable?(error)`

**Returns**:

- (`Boolean`) —

**See**:
- [Source on GitHub](https://github.com/alphagov/slimmer/blob/master/lib/slimmer/skin.rb#L72)

### `#process(processors,body,template, rack_env)`


**See**:
- [Source on GitHub](https://github.com/alphagov/slimmer/blob/master/lib/slimmer/skin.rb#L77)

### `#success(source_request, response, body)`


**See**:
- [Source on GitHub](https://github.com/alphagov/slimmer/blob/master/lib/slimmer/skin.rb#L106)

### `#error(template_name, body, rack_env)`


**See**:
- [Source on GitHub](https://github.com/alphagov/slimmer/blob/master/lib/slimmer/skin.rb#L131)

---

## `class Slimmer::Cache`

### `#use_cache=(value)`

Sets the attribute use_cache

**Params**:

- `value` (``) — the value to set the attribute use_cache to.


**See**:
- [Source on GitHub](https://github.com/alphagov/slimmer/blob/master/lib/slimmer/cache.rb#L6)

### `#cache_ttl=(value)`

Sets the attribute cache_ttl

**Params**:

- `value` (``) — the value to set the attribute cache_ttl to.


**See**:
- [Source on GitHub](https://github.com/alphagov/slimmer/blob/master/lib/slimmer/cache.rb#L6)

### `#initialize`

TODO: use a real cache rather than an in memory hash

**Returns**:

- (`Cache`) — a new instance of Cache

**See**:
- [Source on GitHub](https://github.com/alphagov/slimmer/blob/master/lib/slimmer/cache.rb#L9)

### `#clear`


**See**:
- [Source on GitHub](https://github.com/alphagov/slimmer/blob/master/lib/slimmer/cache.rb#L18)

### `#fetch(key)`


**See**:
- [Source on GitHub](https://github.com/alphagov/slimmer/blob/master/lib/slimmer/cache.rb#L22)

---

## `class Slimmer::I18nBackend`

### `#available_locales`


**See**:
- [Source on GitHub](https://github.com/alphagov/slimmer/blob/master/lib/slimmer/i18n_backend.rb#L7)

### `#lookup(locale, key, scope = [], options = {})`


**See**:
- [Source on GitHub](https://github.com/alphagov/slimmer/blob/master/lib/slimmer/i18n_backend.rb#L14)

---

## `class Slimmer::GovukRequestId`

### `.set?`

**Returns**:

- (`Boolean`) —

**See**:
- [Source on GitHub](https://github.com/alphagov/slimmer/blob/master/lib/slimmer/govuk_request_id.rb#L4)

### `.value`


**See**:
- [Source on GitHub](https://github.com/alphagov/slimmer/blob/master/lib/slimmer/govuk_request_id.rb#L8)

### `.value=(new_id)`


**See**:
- [Source on GitHub](https://github.com/alphagov/slimmer/blob/master/lib/slimmer/govuk_request_id.rb#L12)

---

## `class Slimmer::ComponentResolver`

### `.caching`


**See**:
- [Source on GitHub](https://github.com/alphagov/slimmer/blob/master/lib/slimmer/component_resolver.rb#L8)

### `#find_templates(name, prefix, partial, details, outside_app_allowed = false)`


**See**:
- [Source on GitHub](https://github.com/alphagov/slimmer/blob/master/lib/slimmer/component_resolver.rb#L14)

---

## `class Slimmer::Processors::TagMover`

### `#filter(src,dest)`


**See**:
- [Source on GitHub](https://github.com/alphagov/slimmer/blob/master/lib/slimmer/processors/tag_mover.rb#L3)

### `#include_tag?(node, min_attrs)`

**Returns**:

- (`Boolean`) —

**See**:
- [Source on GitHub](https://github.com/alphagov/slimmer/blob/master/lib/slimmer/processors/tag_mover.rb#L10)

### `#tag_fingerprint(node, attrs)`


**See**:
- [Source on GitHub](https://github.com/alphagov/slimmer/blob/master/lib/slimmer/processors/tag_mover.rb#L14)

### `#wrap_node(src, node)`


**See**:
- [Source on GitHub](https://github.com/alphagov/slimmer/blob/master/lib/slimmer/processors/tag_mover.rb#L24)

### `#move_tags(src, dest, type, opts)`


**See**:
- [Source on GitHub](https://github.com/alphagov/slimmer/blob/master/lib/slimmer/processors/tag_mover.rb#L31)

---

## `class Slimmer::Processors::BodyInserter`

### `#initialize(source_id='wrapper', destination_id='wrapper')`

**Returns**:

- (`BodyInserter`) — a new instance of BodyInserter

**See**:
- [Source on GitHub](https://github.com/alphagov/slimmer/blob/master/lib/slimmer/processors/body_inserter.rb#L3)

### `#filter(src,dest)`


**See**:
- [Source on GitHub](https://github.com/alphagov/slimmer/blob/master/lib/slimmer/processors/body_inserter.rb#L8)

---

## `class Slimmer::Processors::FooterRemover`

### `#filter(src,dest)`


**See**:
- [Source on GitHub](https://github.com/alphagov/slimmer/blob/master/lib/slimmer/processors/footer_remover.rb#L3)

---

## `class Slimmer::Processors::TitleInserter`

### `#filter(src,dest)`


**See**:
- [Source on GitHub](https://github.com/alphagov/slimmer/blob/master/lib/slimmer/processors/title_inserter.rb#L3)

### `#insert_title(title, head)`


**See**:
- [Source on GitHub](https://github.com/alphagov/slimmer/blob/master/lib/slimmer/processors/title_inserter.rb#L11)

---

## `class Slimmer::Processors::SearchRemover`

### `#initialize(headers)`

**Returns**:

- (`SearchRemover`) — a new instance of SearchRemover

**See**:
- [Source on GitHub](https://github.com/alphagov/slimmer/blob/master/lib/slimmer/processors/search_remover.rb#L3)

### `#filter(src,dest)`


**See**:
- [Source on GitHub](https://github.com/alphagov/slimmer/blob/master/lib/slimmer/processors/search_remover.rb#L7)

---

## `class Slimmer::Processors::NavigationMover`

### `#initialize(skin)`

**Returns**:

- (`NavigationMover`) — a new instance of NavigationMover

**See**:
- [Source on GitHub](https://github.com/alphagov/slimmer/blob/master/lib/slimmer/processors/navigation_mover.rb#L3)

### `#filter(src, dest)`


**See**:
- [Source on GitHub](https://github.com/alphagov/slimmer/blob/master/lib/slimmer/processors/navigation_mover.rb#L7)

### `#proposition_header_block`


**See**:
- [Source on GitHub](https://github.com/alphagov/slimmer/blob/master/lib/slimmer/processors/navigation_mover.rb#L22)

---

## `class Slimmer::Processors::MetadataInserter`

### `#initialize(response, app_name)`

**Returns**:

- (`MetadataInserter`) — a new instance of MetadataInserter

**See**:
- [Source on GitHub](https://github.com/alphagov/slimmer/blob/master/lib/slimmer/processors/metadata_inserter.rb#L3)

### `#filter(src, dest)`


**See**:
- [Source on GitHub](https://github.com/alphagov/slimmer/blob/master/lib/slimmer/processors/metadata_inserter.rb#L8)

---

## `class Slimmer::Processors::BodyClassCopier`

### `#filter(src, dest)`


**See**:
- [Source on GitHub](https://github.com/alphagov/slimmer/blob/master/lib/slimmer/processors/body_class_copier.rb#L3)

---

## `class Slimmer::Processors::SearchPathSetter`

### `#initialize(response)`

**Returns**:

- (`SearchPathSetter`) — a new instance of SearchPathSetter

**See**:
- [Source on GitHub](https://github.com/alphagov/slimmer/blob/master/lib/slimmer/processors/search_path_setter.rb#L3)

### `#filter(content_document, page_template)`


**See**:
- [Source on GitHub](https://github.com/alphagov/slimmer/blob/master/lib/slimmer/processors/search_path_setter.rb#L7)

### `#search_scope`


**See**:
- [Source on GitHub](https://github.com/alphagov/slimmer/blob/master/lib/slimmer/processors/search_path_setter.rb#L13)

---

## `class Slimmer::Processors::InsideHeaderInserter`

### `#filter(src, dest)`


**See**:
- [Source on GitHub](https://github.com/alphagov/slimmer/blob/master/lib/slimmer/processors/inside_header_inserter.rb#L3)

---

## `class Slimmer::Processors::HeaderContextInserter`

### `#initialize(path='.header-context')`

**Returns**:

- (`HeaderContextInserter`) — a new instance of HeaderContextInserter

**See**:
- [Source on GitHub](https://github.com/alphagov/slimmer/blob/master/lib/slimmer/processors/header_context_inserter.rb#L3)

### `#filter(src,dest)`


**See**:
- [Source on GitHub](https://github.com/alphagov/slimmer/blob/master/lib/slimmer/processors/header_context_inserter.rb#L7)

---

## `class Slimmer::Processors::ConditionalCommentMover`

### `#filter(src, dest)`


**See**:
- [Source on GitHub](https://github.com/alphagov/slimmer/blob/master/lib/slimmer/processors/conditional_comment_mover.rb#L3)

### `#match_conditional_comments(str)`


**See**:
- [Source on GitHub](https://github.com/alphagov/slimmer/blob/master/lib/slimmer/processors/conditional_comment_mover.rb#L11)

---

## `class Slimmer::Processors::SearchParameterInserter`

### `#initialize(response)`

**Returns**:

- (`SearchParameterInserter`) — a new instance of SearchParameterInserter

**See**:
- [Source on GitHub](https://github.com/alphagov/slimmer/blob/master/lib/slimmer/processors/search_parameter_inserter.rb#L5)

### `#filter(content_document, page_template)`


**See**:
- [Source on GitHub](https://github.com/alphagov/slimmer/blob/master/lib/slimmer/processors/search_parameter_inserter.rb#L9)

### `#add_hidden_input(search_form, name, value)`


**See**:
- [Source on GitHub](https://github.com/alphagov/slimmer/blob/master/lib/slimmer/processors/search_parameter_inserter.rb#L26)

### `#search_parameters`


**See**:
- [Source on GitHub](https://github.com/alphagov/slimmer/blob/master/lib/slimmer/processors/search_parameter_inserter.rb#L34)

### `#parse_search_parameters`


**See**:
- [Source on GitHub](https://github.com/alphagov/slimmer/blob/master/lib/slimmer/processors/search_parameter_inserter.rb#L38)

---

## `class Slimmer::Processors::ReportAProblemInserter`

### `#initialize(skin, url, headers, wrapper_id)`

**Returns**:

- (`ReportAProblemInserter`) — a new instance of ReportAProblemInserter

**See**:
- [Source on GitHub](https://github.com/alphagov/slimmer/blob/master/lib/slimmer/processors/report_a_problem_inserter.rb#L5)

### `#filter(content_document, page_template)`


**See**:
- [Source on GitHub](https://github.com/alphagov/slimmer/blob/master/lib/slimmer/processors/report_a_problem_inserter.rb#L12)

### `#report_a_problem_block`


**See**:
- [Source on GitHub](https://github.com/alphagov/slimmer/blob/master/lib/slimmer/processors/report_a_problem_inserter.rb#L18)

---

## `module Slimmer::Headers`

### `#set_slimmer_headers(hash)`


**See**:
- [Source on GitHub](https://github.com/alphagov/slimmer/blob/master/lib/slimmer/headers.rb#L35)

---

## `module Slimmer::Template`

### `#slimmer_template template_name`


**See**:
- [Source on GitHub](https://github.com/alphagov/slimmer/blob/master/lib/slimmer/template.rb#L7)

---

## `module Slimmer::Template::ClassMethods`

### `#slimmer_template template_name`


**See**:
- [Source on GitHub](https://github.com/alphagov/slimmer/blob/master/lib/slimmer/template.rb#L13)

---

## `module Slimmer::GovukComponents`

### `#add_govuk_components`


**See**:
- [Source on GitHub](https://github.com/alphagov/slimmer/blob/master/lib/slimmer/govuk_components.rb#L7)

---

## `module Slimmer::TestHelpers::GovukComponents`

### `#stub_shared_component_locales`


**See**:
- [Source on GitHub](https://github.com/alphagov/slimmer/blob/master/lib/slimmer/test_helpers/govuk_components.rb#L6)

### `#shared_component_selector(name)`


**See**:
- [Source on GitHub](https://github.com/alphagov/slimmer/blob/master/lib/slimmer/test_helpers/govuk_components.rb#L13)

---
