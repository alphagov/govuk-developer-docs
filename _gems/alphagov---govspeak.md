---
layout: gem_layout
title: govspeak
---

## `class Govspeak::Document`

### `#images`

Returns the value of attribute images

**See**:
- [Source on GitHub](https://github.com/alphagov/govspeak/blob/master/lib/govspeak.rb#L27)

### `#images=(value)`

Sets the attribute images

**Params**:

- `value` (``) — the value to set the attribute images to.


**See**:
- [Source on GitHub](https://github.com/alphagov/govspeak/blob/master/lib/govspeak.rb#L27)

### `#attachments`

Returns the value of attribute attachments

**See**:
- [Source on GitHub](https://github.com/alphagov/govspeak/blob/master/lib/govspeak.rb#L28)

### `#contacts`

Returns the value of attribute contacts

**See**:
- [Source on GitHub](https://github.com/alphagov/govspeak/blob/master/lib/govspeak.rb#L28)

### `#links`

Returns the value of attribute links

**See**:
- [Source on GitHub](https://github.com/alphagov/govspeak/blob/master/lib/govspeak.rb#L28)

### `#locale`

Returns the value of attribute locale

**See**:
- [Source on GitHub](https://github.com/alphagov/govspeak/blob/master/lib/govspeak.rb#L28)

### `.to_html(source, options = {})`


**See**:
- [Source on GitHub](https://github.com/alphagov/govspeak/blob/master/lib/govspeak.rb#L30)

### `#initialize(source, options = {})`

**Returns**:

- (`Document`) — a new instance of Document

**See**:
- [Source on GitHub](https://github.com/alphagov/govspeak/blob/master/lib/govspeak.rb#L34)

### `#to_html`


**See**:
- [Source on GitHub](https://github.com/alphagov/govspeak/blob/master/lib/govspeak.rb#L59)

### `#to_liquid`


**See**:
- [Source on GitHub](https://github.com/alphagov/govspeak/blob/master/lib/govspeak.rb#L63)

### `#t(*args)`


**See**:
- [Source on GitHub](https://github.com/alphagov/govspeak/blob/master/lib/govspeak.rb#L67)

### `#to_sanitized_html`


**See**:
- [Source on GitHub](https://github.com/alphagov/govspeak/blob/master/lib/govspeak.rb#L73)

### `#to_sanitized_html_without_images`


**See**:
- [Source on GitHub](https://github.com/alphagov/govspeak/blob/master/lib/govspeak.rb#L77)

### `#to_text`


**See**:
- [Source on GitHub](https://github.com/alphagov/govspeak/blob/master/lib/govspeak.rb#L81)

### `#valid?(validation_options = {})`

**Returns**:

- (`Boolean`) —

**See**:
- [Source on GitHub](https://github.com/alphagov/govspeak/blob/master/lib/govspeak.rb#L85)

### `#headers`


**See**:
- [Source on GitHub](https://github.com/alphagov/govspeak/blob/master/lib/govspeak.rb#L89)

### `#structured_headers`


**See**:
- [Source on GitHub](https://github.com/alphagov/govspeak/blob/master/lib/govspeak.rb#L93)

### `#preprocess(source)`


**See**:
- [Source on GitHub](https://github.com/alphagov/govspeak/blob/master/lib/govspeak.rb#L97)

### `.extension(title, regexp = nil, &block)`


**See**:
- [Source on GitHub](https://github.com/alphagov/govspeak/blob/master/lib/govspeak.rb#L112)

### `.surrounded_by(open, close=nil)`


**See**:
- [Source on GitHub](https://github.com/alphagov/govspeak/blob/master/lib/govspeak.rb#L117)

### `.wrap_with_div(class_name, character, parser=Kramdown::Document)`


**See**:
- [Source on GitHub](https://github.com/alphagov/govspeak/blob/master/lib/govspeak.rb#L127)

### `#insert_strong_inside_p(body, parser=Govspeak::Document)`


**See**:
- [Source on GitHub](https://github.com/alphagov/govspeak/blob/master/lib/govspeak.rb#L134)

### `#render_image(url, alt_text, caption = nil, id = nil)`

As of version 1.12.0 of Kramdown the block elements (div & figcaption)
inside this html block will have it's < > converted into HTML Entities
when ever this code is used inside block level elements.

To resolve this we have a post-processing task that will convert this
back into HTML (I know - it's ugly). The way we could resolve this
without ugliness would be to output only inline elements which rules
out div and figcaption

This issue is not considered a bug by kramdown: https://github.com/gettalong/kramdown/issues/191

**See**:
- [Source on GitHub](https://github.com/alphagov/govspeak/blob/master/lib/govspeak.rb#L230)

### `.devolved_options`


**See**:
- [Source on GitHub](https://github.com/alphagov/govspeak/blob/master/lib/govspeak.rb#L271)

---

## `class Govspeak::CLI`

### `#run`


**See**:
- [Source on GitHub](https://github.com/alphagov/govspeak/blob/master/lib/govspeak/cli.rb#L9)

---

## `class Govspeak::HtmlValidator`

### `#govspeak_string`

Returns the value of attribute govspeak_string

**See**:
- [Source on GitHub](https://github.com/alphagov/govspeak/blob/master/lib/govspeak/html_validator.rb#L2)

### `#initialize(govspeak_string, sanitization_options = {})`

**Returns**:

- (`HtmlValidator`) — a new instance of HtmlValidator

**See**:
- [Source on GitHub](https://github.com/alphagov/govspeak/blob/master/lib/govspeak/html_validator.rb#L4)

### `#invalid?`

**Returns**:

- (`Boolean`) —

**See**:
- [Source on GitHub](https://github.com/alphagov/govspeak/blob/master/lib/govspeak/html_validator.rb#L9)

### `#valid?`

**Returns**:

- (`Boolean`) —

**See**:
- [Source on GitHub](https://github.com/alphagov/govspeak/blob/master/lib/govspeak/html_validator.rb#L13)

### `#normalise_html(html)`

Make whitespace in html tags consistent

**See**:
- [Source on GitHub](https://github.com/alphagov/govspeak/blob/master/lib/govspeak/html_validator.rb#L20)

### `#govspeak_to_html`


**See**:
- [Source on GitHub](https://github.com/alphagov/govspeak/blob/master/lib/govspeak/html_validator.rb#L24)

---

## `class Govspeak::HtmlSanitizer`

### `#initialize(dirty_html, options = {})`

**Returns**:

- (`HtmlSanitizer`) — a new instance of HtmlSanitizer

**See**:
- [Source on GitHub](https://github.com/alphagov/govspeak/blob/master/lib/govspeak/html_sanitizer.rb#L41)

### `#sanitize`


**See**:
- [Source on GitHub](https://github.com/alphagov/govspeak/blob/master/lib/govspeak/html_sanitizer.rb#L46)

### `#sanitize_without_images`


**See**:
- [Source on GitHub](https://github.com/alphagov/govspeak/blob/master/lib/govspeak/html_sanitizer.rb#L54)

### `#sanitize_config`


**See**:
- [Source on GitHub](https://github.com/alphagov/govspeak/blob/master/lib/govspeak/html_sanitizer.rb#L60)

---

## `class Govspeak::HtmlSanitizer::ImageSourceWhitelister`

### `#initialize(allowed_image_hosts)`

**Returns**:

- (`ImageSourceWhitelister`) — a new instance of ImageSourceWhitelister

**See**:
- [Source on GitHub](https://github.com/alphagov/govspeak/blob/master/lib/govspeak/html_sanitizer.rb#L9)

### `#call(sanitize_context)`


**See**:
- [Source on GitHub](https://github.com/alphagov/govspeak/blob/master/lib/govspeak/html_sanitizer.rb#L13)

---

## `class Govspeak::HtmlSanitizer::TableCellTextAlignWhitelister`

### `#call(sanitize_context)`


**See**:
- [Source on GitHub](https://github.com/alphagov/govspeak/blob/master/lib/govspeak/html_sanitizer.rb#L25)

### `#invalid_style_attribute?(style)`

**Returns**:

- (`Boolean`) —

**See**:
- [Source on GitHub](https://github.com/alphagov/govspeak/blob/master/lib/govspeak/html_sanitizer.rb#L36)

---

## `class Govspeak::PostProcessor`

### `#input`

Returns the value of attribute input

**See**:
- [Source on GitHub](https://github.com/alphagov/govspeak/blob/master/lib/govspeak/post_processor.rb#L5)

### `#initialize(html)`

**Returns**:

- (`PostProcessor`) — a new instance of PostProcessor

**See**:
- [Source on GitHub](https://github.com/alphagov/govspeak/blob/master/lib/govspeak/post_processor.rb#L9)

### `.process(html)`


**See**:
- [Source on GitHub](https://github.com/alphagov/govspeak/blob/master/lib/govspeak/post_processor.rb#L20)

### `.extension(title, &block)`


**See**:
- [Source on GitHub](https://github.com/alphagov/govspeak/blob/master/lib/govspeak/post_processor.rb#L24)

### `#output`


**See**:
- [Source on GitHub](https://github.com/alphagov/govspeak/blob/master/lib/govspeak/post_processor.rb#L28)

---

## `class Govspeak::Header`

### `#text=(value)`

Sets the attribute text

**Params**:

- `value` (`Object`) — the value to set the attribute text to.


**Returns**:

- (`Object`) — the newly set value

**See**:
- [Source on GitHub](https://github.com/alphagov/govspeak/blob/master/lib/govspeak/header_extractor.rb#L2)

### `#text`

Returns the value of attribute text

**Returns**:

- (`Object`) — the current value of text

**See**:
- [Source on GitHub](https://github.com/alphagov/govspeak/blob/master/lib/govspeak/header_extractor.rb#L2)

### `#level=(value)`

Sets the attribute level

**Params**:

- `value` (`Object`) — the value to set the attribute level to.


**Returns**:

- (`Object`) — the newly set value

**See**:
- [Source on GitHub](https://github.com/alphagov/govspeak/blob/master/lib/govspeak/header_extractor.rb#L2)

### `#level`

Returns the value of attribute level

**Returns**:

- (`Object`) — the current value of level

**See**:
- [Source on GitHub](https://github.com/alphagov/govspeak/blob/master/lib/govspeak/header_extractor.rb#L2)

### `#id=(value)`

Sets the attribute id

**Params**:

- `value` (`Object`) — the value to set the attribute id to.


**Returns**:

- (`Object`) — the newly set value

**See**:
- [Source on GitHub](https://github.com/alphagov/govspeak/blob/master/lib/govspeak/header_extractor.rb#L2)

### `#id`

Returns the value of attribute id

**Returns**:

- (`Object`) — the current value of id

**See**:
- [Source on GitHub](https://github.com/alphagov/govspeak/blob/master/lib/govspeak/header_extractor.rb#L2)

---

## `class Govspeak::HeaderExtractor`

### `#convert(doc)`


**See**:
- [Source on GitHub](https://github.com/alphagov/govspeak/blob/master/lib/govspeak/header_extractor.rb#L5)

---

## `class Govspeak::StructuredHeader`

### `#text=(value)`

Sets the attribute text

**Params**:

- `value` (`Object`) — the value to set the attribute text to.


**Returns**:

- (`Object`) — the newly set value

**See**:
- [Source on GitHub](https://github.com/alphagov/govspeak/blob/master/lib/govspeak/structured_header_extractor.rb#L3)

### `#text`

Returns the value of attribute text

**Returns**:

- (`Object`) — the current value of text

**See**:
- [Source on GitHub](https://github.com/alphagov/govspeak/blob/master/lib/govspeak/structured_header_extractor.rb#L3)

### `#level=(value)`

Sets the attribute level

**Params**:

- `value` (`Object`) — the value to set the attribute level to.


**Returns**:

- (`Object`) — the newly set value

**See**:
- [Source on GitHub](https://github.com/alphagov/govspeak/blob/master/lib/govspeak/structured_header_extractor.rb#L3)

### `#level`

Returns the value of attribute level

**Returns**:

- (`Object`) — the current value of level

**See**:
- [Source on GitHub](https://github.com/alphagov/govspeak/blob/master/lib/govspeak/structured_header_extractor.rb#L3)

### `#id=(value)`

Sets the attribute id

**Params**:

- `value` (`Object`) — the value to set the attribute id to.


**Returns**:

- (`Object`) — the newly set value

**See**:
- [Source on GitHub](https://github.com/alphagov/govspeak/blob/master/lib/govspeak/structured_header_extractor.rb#L3)

### `#id`

Returns the value of attribute id

**Returns**:

- (`Object`) — the current value of id

**See**:
- [Source on GitHub](https://github.com/alphagov/govspeak/blob/master/lib/govspeak/structured_header_extractor.rb#L3)

### `#headers=(value)`

Sets the attribute headers

**Params**:

- `value` (`Object`) — the value to set the attribute headers to.


**Returns**:

- (`Object`) — the newly set value

**See**:
- [Source on GitHub](https://github.com/alphagov/govspeak/blob/master/lib/govspeak/structured_header_extractor.rb#L3)

### `#headers`

Returns the value of attribute headers

**Returns**:

- (`Object`) — the current value of headers

**See**:
- [Source on GitHub](https://github.com/alphagov/govspeak/blob/master/lib/govspeak/structured_header_extractor.rb#L3)

---

## `class Govspeak::StructuredHeaderExtractor`

### `#initialize(document)`

**Returns**:

- (`StructuredHeaderExtractor`) — a new instance of StructuredHeaderExtractor

**See**:
- [Source on GitHub](https://github.com/alphagov/govspeak/blob/master/lib/govspeak/structured_header_extractor.rb#L20)

### `#call`


**See**:
- [Source on GitHub](https://github.com/alphagov/govspeak/blob/master/lib/govspeak/structured_header_extractor.rb#L26)

### `#headers_list`


**See**:
- [Source on GitHub](https://github.com/alphagov/govspeak/blob/master/lib/govspeak/structured_header_extractor.rb#L51)

### `#add_top_level(header)`


**See**:
- [Source on GitHub](https://github.com/alphagov/govspeak/blob/master/lib/govspeak/structured_header_extractor.rb#L57)

### `#add_sibling(header)`


**See**:
- [Source on GitHub](https://github.com/alphagov/govspeak/blob/master/lib/govspeak/structured_header_extractor.rb#L62)

### `#add_child(header)`


**See**:
- [Source on GitHub](https://github.com/alphagov/govspeak/blob/master/lib/govspeak/structured_header_extractor.rb#L67)

### `#add_uncle_or_aunt(header)`


**See**:
- [Source on GitHub](https://github.com/alphagov/govspeak/blob/master/lib/govspeak/structured_header_extractor.rb#L71)

### `#header_higher_than_top_level?(header)`

**Returns**:

- (`Boolean`) —

**See**:
- [Source on GitHub](https://github.com/alphagov/govspeak/blob/master/lib/govspeak/structured_header_extractor.rb#L76)

### `#header_at_same_level_as_prev?(header)`

**Returns**:

- (`Boolean`) —

**See**:
- [Source on GitHub](https://github.com/alphagov/govspeak/blob/master/lib/govspeak/structured_header_extractor.rb#L80)

### `#header_one_level_lower_than_prev?(header)`

**Returns**:

- (`Boolean`) —

**See**:
- [Source on GitHub](https://github.com/alphagov/govspeak/blob/master/lib/govspeak/structured_header_extractor.rb#L84)

### `#header_at_higher_level_than_prev?(header)`

**Returns**:

- (`Boolean`) —

**See**:
- [Source on GitHub](https://github.com/alphagov/govspeak/blob/master/lib/govspeak/structured_header_extractor.rb#L89)

### `#pop_stack_to_level(header)`


**See**:
- [Source on GitHub](https://github.com/alphagov/govspeak/blob/master/lib/govspeak/structured_header_extractor.rb#L94)

### `#reset_stack`


**See**:
- [Source on GitHub](https://github.com/alphagov/govspeak/blob/master/lib/govspeak/structured_header_extractor.rb#L99)

---

## `class Govspeak::HCardPresenter`

### `.from_contact(contact)`


**See**:
- [Source on GitHub](https://github.com/alphagov/govspeak/blob/master/lib/govspeak/presenters/h_card_presenter.rb#L3)

### `.contact_properties(contact)`


**See**:
- [Source on GitHub](https://github.com/alphagov/govspeak/blob/master/lib/govspeak/presenters/h_card_presenter.rb#L7)

### `.country_name(contact)`


**See**:
- [Source on GitHub](https://github.com/alphagov/govspeak/blob/master/lib/govspeak/presenters/h_card_presenter.rb#L16)

### `.property_keys`


**See**:
- [Source on GitHub](https://github.com/alphagov/govspeak/blob/master/lib/govspeak/presenters/h_card_presenter.rb#L20)

### `.address_formats`


**See**:
- [Source on GitHub](https://github.com/alphagov/govspeak/blob/master/lib/govspeak/presenters/h_card_presenter.rb#L24)

### `#properties`

Returns the value of attribute properties

**See**:
- [Source on GitHub](https://github.com/alphagov/govspeak/blob/master/lib/govspeak/presenters/h_card_presenter.rb#L28)

### `#country_code`

Returns the value of attribute country_code

**See**:
- [Source on GitHub](https://github.com/alphagov/govspeak/blob/master/lib/govspeak/presenters/h_card_presenter.rb#L28)

### `#initialize(properties, country_code)`

**Returns**:

- (`HCardPresenter`) — a new instance of HCardPresenter

**See**:
- [Source on GitHub](https://github.com/alphagov/govspeak/blob/master/lib/govspeak/presenters/h_card_presenter.rb#L30)

### `#render`


**See**:
- [Source on GitHub](https://github.com/alphagov/govspeak/blob/master/lib/govspeak/presenters/h_card_presenter.rb#L35)

### `#interpolate_address_property(property_name)`


**See**:
- [Source on GitHub](https://github.com/alphagov/govspeak/blob/master/lib/govspeak/presenters/h_card_presenter.rb#L39)

---

## `class Govspeak::ContactPresenter`

### `#contact`

Returns the value of attribute contact

**See**:
- [Source on GitHub](https://github.com/alphagov/govspeak/blob/master/lib/govspeak/presenters/contact_presenter.rb#L6)

### `#initialize(contact)`

**Returns**:

- (`ContactPresenter`) — a new instance of ContactPresenter

**See**:
- [Source on GitHub](https://github.com/alphagov/govspeak/blob/master/lib/govspeak/presenters/contact_presenter.rb#L11)

### `#contact_numbers`


**See**:
- [Source on GitHub](https://github.com/alphagov/govspeak/blob/master/lib/govspeak/presenters/contact_presenter.rb#L15)

### `#has_postal_address?`

**Returns**:

- (`Boolean`) —

**See**:
- [Source on GitHub](https://github.com/alphagov/govspeak/blob/master/lib/govspeak/presenters/contact_presenter.rb#L19)

---

## `class Govspeak::AttachmentPresenter`

### `#attachment`

Returns the value of attribute attachment

**See**:
- [Source on GitHub](https://github.com/alphagov/govspeak/blob/master/lib/govspeak/presenters/attachment_presenter.rb#L7)

### `#initialize(attachment)`

**Returns**:

- (`AttachmentPresenter`) — a new instance of AttachmentPresenter

**See**:
- [Source on GitHub](https://github.com/alphagov/govspeak/blob/master/lib/govspeak/presenters/attachment_presenter.rb#L13)

### `#id`


**See**:
- [Source on GitHub](https://github.com/alphagov/govspeak/blob/master/lib/govspeak/presenters/attachment_presenter.rb#L17)

### `#order_url`


**See**:
- [Source on GitHub](https://github.com/alphagov/govspeak/blob/master/lib/govspeak/presenters/attachment_presenter.rb#L21)

### `#opendocument?`

**Returns**:

- (`Boolean`) —

**See**:
- [Source on GitHub](https://github.com/alphagov/govspeak/blob/master/lib/govspeak/presenters/attachment_presenter.rb#L25)

### `#url`


**See**:
- [Source on GitHub](https://github.com/alphagov/govspeak/blob/master/lib/govspeak/presenters/attachment_presenter.rb#L29)

### `#external?`

**Returns**:

- (`Boolean`) —

**See**:
- [Source on GitHub](https://github.com/alphagov/govspeak/blob/master/lib/govspeak/presenters/attachment_presenter.rb#L33)

### `#price`


**See**:
- [Source on GitHub](https://github.com/alphagov/govspeak/blob/master/lib/govspeak/presenters/attachment_presenter.rb#L37)

### `#accessible?`

**Returns**:

- (`Boolean`) —

**See**:
- [Source on GitHub](https://github.com/alphagov/govspeak/blob/master/lib/govspeak/presenters/attachment_presenter.rb#L42)

### `#thumbnail_link`


**See**:
- [Source on GitHub](https://github.com/alphagov/govspeak/blob/master/lib/govspeak/presenters/attachment_presenter.rb#L46)

### `#help_block_toggle_id`


**See**:
- [Source on GitHub](https://github.com/alphagov/govspeak/blob/master/lib/govspeak/presenters/attachment_presenter.rb#L52)

### `#section_class`


**See**:
- [Source on GitHub](https://github.com/alphagov/govspeak/blob/master/lib/govspeak/presenters/attachment_presenter.rb#L56)

### `#mail_to(email_address, name, options = {})`


**See**:
- [Source on GitHub](https://github.com/alphagov/govspeak/blob/master/lib/govspeak/presenters/attachment_presenter.rb#L60)

### `#alternative_format_order_link`


**See**:
- [Source on GitHub](https://github.com/alphagov/govspeak/blob/master/lib/govspeak/presenters/attachment_presenter.rb#L65)

### `#body_for_mail(attachment_info)`


**See**:
- [Source on GitHub](https://github.com/alphagov/govspeak/blob/master/lib/govspeak/presenters/attachment_presenter.rb#L85)

### `#alternative_format_contact_email`


**See**:
- [Source on GitHub](https://github.com/alphagov/govspeak/blob/master/lib/govspeak/presenters/attachment_presenter.rb#L98)

### `#attachment_thumbnail`

FIXME: usage of image_tag will cause these to render at /images/ which seems
very host dependent. I assume this will need links to static urls.

**See**:
- [Source on GitHub](https://github.com/alphagov/govspeak/blob/master/lib/govspeak/presenters/attachment_presenter.rb#L104)

### `#reference`


**See**:
- [Source on GitHub](https://github.com/alphagov/govspeak/blob/master/lib/govspeak/presenters/attachment_presenter.rb#L118)

### `#references_for_title`

FIXME this has english in it so will cause problems if the locale is not en

**See**:
- [Source on GitHub](https://github.com/alphagov/govspeak/blob/master/lib/govspeak/presenters/attachment_presenter.rb#L141)

### `#references?`

**Returns**:

- (`Boolean`) —

**See**:
- [Source on GitHub](https://github.com/alphagov/govspeak/blob/master/lib/govspeak/presenters/attachment_presenter.rb#L151)

### `#attachment_class`


**See**:
- [Source on GitHub](https://github.com/alphagov/govspeak/blob/master/lib/govspeak/presenters/attachment_presenter.rb#L155)

### `#unnumbered_paper?`

**Returns**:

- (`Boolean`) —

**See**:
- [Source on GitHub](https://github.com/alphagov/govspeak/blob/master/lib/govspeak/presenters/attachment_presenter.rb#L159)

### `#unnumbered_command_paper?`

**Returns**:

- (`Boolean`) —

**See**:
- [Source on GitHub](https://github.com/alphagov/govspeak/blob/master/lib/govspeak/presenters/attachment_presenter.rb#L163)

### `#download_link`


**See**:
- [Source on GitHub](https://github.com/alphagov/govspeak/blob/master/lib/govspeak/presenters/attachment_presenter.rb#L167)

### `#attachment_attributes`


**See**:
- [Source on GitHub](https://github.com/alphagov/govspeak/blob/master/lib/govspeak/presenters/attachment_presenter.rb#L173)

### `#preview_url`


**See**:
- [Source on GitHub](https://github.com/alphagov/govspeak/blob/master/lib/govspeak/presenters/attachment_presenter.rb#L187)

### `#file_abbr_tag(abbr, title)`


**See**:
- [Source on GitHub](https://github.com/alphagov/govspeak/blob/master/lib/govspeak/presenters/attachment_presenter.rb#L195)

### `#humanized_content_type(file_extension)`


**See**:
- [Source on GitHub](https://github.com/alphagov/govspeak/blob/master/lib/govspeak/presenters/attachment_presenter.rb#L199)

### `#previewable?`

**Returns**:

- (`Boolean`) —

**See**:
- [Source on GitHub](https://github.com/alphagov/govspeak/blob/master/lib/govspeak/presenters/attachment_presenter.rb#L238)

### `#title`


**See**:
- [Source on GitHub](https://github.com/alphagov/govspeak/blob/master/lib/govspeak/presenters/attachment_presenter.rb#L242)

### `#file_extension`


**See**:
- [Source on GitHub](https://github.com/alphagov/govspeak/blob/master/lib/govspeak/presenters/attachment_presenter.rb#L246)

### `#hide_thumbnail?`

**Returns**:

- (`Boolean`) —

**See**:
- [Source on GitHub](https://github.com/alphagov/govspeak/blob/master/lib/govspeak/presenters/attachment_presenter.rb#L253)

### `#attachment_details`


**See**:
- [Source on GitHub](https://github.com/alphagov/govspeak/blob/master/lib/govspeak/presenters/attachment_presenter.rb#L257)

### `#title_link_options`


**See**:
- [Source on GitHub](https://github.com/alphagov/govspeak/blob/master/lib/govspeak/presenters/attachment_presenter.rb#L262)

### `#help_block_id`


**See**:
- [Source on GitHub](https://github.com/alphagov/govspeak/blob/master/lib/govspeak/presenters/attachment_presenter.rb#L269)

### `#link(body, url, options = {})`


**See**:
- [Source on GitHub](https://github.com/alphagov/govspeak/blob/master/lib/govspeak/presenters/attachment_presenter.rb#L273)

---

## `class Kramdown::Options::AlwaysEqual`

### `#==(other)`


**See**:
- [Source on GitHub](https://github.com/alphagov/govspeak/blob/master/lib/kramdown/parser/kramdown_with_automatic_external_links.rb#L7)

---

## `class Kramdown::Parser::KramdownWithAutomaticExternalLinks`

### `#initialize(source, options)`

**Returns**:

- (`KramdownWithAutomaticExternalLinks`) — a new instance of KramdownWithAutomaticExternalLinks

**See**:
- [Source on GitHub](https://github.com/alphagov/govspeak/blob/master/lib/kramdown/parser/kramdown_with_automatic_external_links.rb#L24)

### `#add_link(el, href, title, alt_text = nil, ial = nil)`


**See**:
- [Source on GitHub](https://github.com/alphagov/govspeak/blob/master/lib/kramdown/parser/kramdown_with_automatic_external_links.rb#L29)

---

## `module WithDeepMerge`

### `#deep_merge(base_object, other_object)`


**See**:
- [Source on GitHub](https://github.com/alphagov/govspeak/blob/master/lib/with_deep_merge.rb#L2)

---

## `module Govspeak::KramdownOverrides`

### `.with_kramdown_ordered_lists_disabled`

 This depends on two internal parts of Kramdown.
1. Parser registry (kramdown/parser/kramdown.rb#define_parser)
2. Kramdown list regexes (kramdown/parser/kramdown/list.rb)
 Updating the Kramdown gem therefore also means updating this file to to
match Kramdown's internals.

**See**:
- [Source on GitHub](https://github.com/alphagov/govspeak/blob/master/lib/govspeak/kramdown_overrides.rb#L9)

---

## `module Govspeak::BlockquoteExtraQuoteRemover`

### `.remove(source)`

used to remove quotes from a markdown blockquote, as these will be inserted
as part of the rendering

for example:
> "test"

will be formatted to:
> test

**See**:
- [Source on GitHub](https://github.com/alphagov/govspeak/blob/master/lib/govspeak/blockquote_extra_quote_remover.rb#L14)

---
