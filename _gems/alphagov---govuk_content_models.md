---
layout: gem_layout
title: govuk_content_models
---

## `class User`

### `.collection_name`

Let an app configure the collection name to use, e.g. set a constant in an
initializer

**See**:
- [Source on GitHub](https://github.com/alphagov/govuk_content_models/blob/master/app/models/user.rb#L13)

### `#to_s`


**See**:
- [Source on GitHub](https://github.com/alphagov/govuk_content_models/blob/master/app/models/user.rb#L36)

### `#gravatar_url(opts = {})`


**See**:
- [Source on GitHub](https://github.com/alphagov/govuk_content_models/blob/master/app/models/user.rb#L40)

### `#progress(edition, action_attributes)`


**See**:
- [Source on GitHub](https://github.com/alphagov/govuk_content_models/blob/master/app/models/user.rb#L49)

### `#record_note(edition, comment, type = Action::NOTE)`


**See**:
- [Source on GitHub](https://github.com/alphagov/govuk_content_models/blob/master/app/models/user.rb#L57)

### `#resolve_important_note(edition)`


**See**:
- [Source on GitHub](https://github.com/alphagov/govuk_content_models/blob/master/app/models/user.rb#L61)

### `#create_edition(format, attributes = {})`


**See**:
- [Source on GitHub](https://github.com/alphagov/govuk_content_models/blob/master/app/models/user.rb#L65)

### `#new_version(edition, convert_to = nil)`


**See**:
- [Source on GitHub](https://github.com/alphagov/govuk_content_models/blob/master/app/models/user.rb#L69)

### `#assign(edition, recipient)`


**See**:
- [Source on GitHub](https://github.com/alphagov/govuk_content_models/blob/master/app/models/user.rb#L73)

### `#unassign(edition)`


**See**:
- [Source on GitHub](https://github.com/alphagov/govuk_content_models/blob/master/app/models/user.rb#L77)

---

## `class Action`

### `#container_class_name(edition)`


**See**:
- [Source on GitHub](https://github.com/alphagov/govuk_content_models/blob/master/app/models/action.rb#L44)

### `#status_action?`

**Returns**:

- (`Boolean`) —

**See**:
- [Source on GitHub](https://github.com/alphagov/govuk_content_models/blob/master/app/models/action.rb#L48)

### `#to_s`


**See**:
- [Source on GitHub](https://github.com/alphagov/govuk_content_models/blob/master/app/models/action.rb#L52)

### `#is_fact_check_request?`

**Returns**:

- (`Boolean`) —

**See**:
- [Source on GitHub](https://github.com/alphagov/govuk_content_models/blob/master/app/models/action.rb#L62)

---

## `class Edition`

### `#admin_list_title`


**See**:
- [Source on GitHub](https://github.com/alphagov/govuk_content_models/blob/master/app/models/edition.rb#L64)

### `#series`


**See**:
- [Source on GitHub](https://github.com/alphagov/govuk_content_models/blob/master/app/models/edition.rb#L66)

### `#history`


**See**:
- [Source on GitHub](https://github.com/alphagov/govuk_content_models/blob/master/app/models/edition.rb#L70)

### `#siblings`


**See**:
- [Source on GitHub](https://github.com/alphagov/govuk_content_models/blob/master/app/models/edition.rb#L74)

### `#previous_siblings`


**See**:
- [Source on GitHub](https://github.com/alphagov/govuk_content_models/blob/master/app/models/edition.rb#L78)

### `#subsequent_siblings`


**See**:
- [Source on GitHub](https://github.com/alphagov/govuk_content_models/blob/master/app/models/edition.rb#L82)

### `#latest_edition?`

**Returns**:

- (`Boolean`) —

**See**:
- [Source on GitHub](https://github.com/alphagov/govuk_content_models/blob/master/app/models/edition.rb#L86)

### `#published_edition`


**See**:
- [Source on GitHub](https://github.com/alphagov/govuk_content_models/blob/master/app/models/edition.rb#L90)

### `#previous_published_edition`


**See**:
- [Source on GitHub](https://github.com/alphagov/govuk_content_models/blob/master/app/models/edition.rb#L94)

### `#in_progress_sibling`


**See**:
- [Source on GitHub](https://github.com/alphagov/govuk_content_models/blob/master/app/models/edition.rb#L98)

### `#can_create_new_edition?`

**Returns**:

- (`Boolean`) —

**See**:
- [Source on GitHub](https://github.com/alphagov/govuk_content_models/blob/master/app/models/edition.rb#L102)

### `#major_updates_in_series`


**See**:
- [Source on GitHub](https://github.com/alphagov/govuk_content_models/blob/master/app/models/edition.rb#L106)

### `#latest_major_update`


**See**:
- [Source on GitHub](https://github.com/alphagov/govuk_content_models/blob/master/app/models/edition.rb#L110)

### `#latest_change_note`


**See**:
- [Source on GitHub](https://github.com/alphagov/govuk_content_models/blob/master/app/models/edition.rb#L114)

### `#public_updated_at`


**See**:
- [Source on GitHub](https://github.com/alphagov/govuk_content_models/blob/master/app/models/edition.rb#L120)

### `#has_ever_been_published?`

**Returns**:

- (`Boolean`) —

**See**:
- [Source on GitHub](https://github.com/alphagov/govuk_content_models/blob/master/app/models/edition.rb#L128)

### `#first_edition_of_published`


**See**:
- [Source on GitHub](https://github.com/alphagov/govuk_content_models/blob/master/app/models/edition.rb#L132)

### `#meta_data`


**See**:
- [Source on GitHub](https://github.com/alphagov/govuk_content_models/blob/master/app/models/edition.rb#L136)

### `#get_next_version_number`


**See**:
- [Source on GitHub](https://github.com/alphagov/govuk_content_models/blob/master/app/models/edition.rb#L140)

### `#indexable_content`


**See**:
- [Source on GitHub](https://github.com/alphagov/govuk_content_models/blob/master/app/models/edition.rb#L145)

### `#indexable_content_without_parts`


**See**:
- [Source on GitHub](https://github.com/alphagov/govuk_content_models/blob/master/app/models/edition.rb#L149)

### `#indexable_content_with_parts`


**See**:
- [Source on GitHub](https://github.com/alphagov/govuk_content_models/blob/master/app/models/edition.rb#L157)

### `#fields_to_copy(target_class)`

If the new clone is of the same type, we can copy all its fields over; if
we are changing the type of the edition, any fields other than the base
fields will likely be meaningless.

**See**:
- [Source on GitHub](https://github.com/alphagov/govuk_content_models/blob/master/app/models/edition.rb#L168)

### `#build_clone(target_class=nil)`


**See**:
- [Source on GitHub](https://github.com/alphagov/govuk_content_models/blob/master/app/models/edition.rb#L176)

### `#clone_whole_body_from(origin_edition)`


**See**:
- [Source on GitHub](https://github.com/alphagov/govuk_content_models/blob/master/app/models/edition.rb#L207)

### `#cloning_between_parted_types?(new_edition)`

**Returns**:

- (`Boolean`) —

**See**:
- [Source on GitHub](https://github.com/alphagov/govuk_content_models/blob/master/app/models/edition.rb#L222)

### `.find_or_create_from_panopticon_data(panopticon_id, importing_user)`


**See**:
- [Source on GitHub](https://github.com/alphagov/govuk_content_models/blob/master/app/models/edition.rb#L226)

### `.find_and_identify(slug, edition)`


**See**:
- [Source on GitHub](https://github.com/alphagov/govuk_content_models/blob/master/app/models/edition.rb#L239)

### `#format`


**See**:
- [Source on GitHub](https://github.com/alphagov/govuk_content_models/blob/master/app/models/edition.rb#L251)

### `#format_name`


**See**:
- [Source on GitHub](https://github.com/alphagov/govuk_content_models/blob/master/app/models/edition.rb#L255)

### `#has_video?`

**Returns**:

- (`Boolean`) —

**See**:
- [Source on GitHub](https://github.com/alphagov/govuk_content_models/blob/master/app/models/edition.rb#L259)

### `#safe_to_preview?`

**Returns**:

- (`Boolean`) —

**See**:
- [Source on GitHub](https://github.com/alphagov/govuk_content_models/blob/master/app/models/edition.rb#L263)

### `#has_sibling_in_progress?`

**Returns**:

- (`Boolean`) —

**See**:
- [Source on GitHub](https://github.com/alphagov/govuk_content_models/blob/master/app/models/edition.rb#L267)

### `#broadcast_action(callback_action)`

Stop broadcasting a delete message unless there are no siblings.

**See**:
- [Source on GitHub](https://github.com/alphagov/govuk_content_models/blob/master/app/models/edition.rb#L272)

### `#was_published`


**See**:
- [Source on GitHub](https://github.com/alphagov/govuk_content_models/blob/master/app/models/edition.rb#L278)

### `#update_slug_from_artefact(artefact)`


**See**:
- [Source on GitHub](https://github.com/alphagov/govuk_content_models/blob/master/app/models/edition.rb#L283)

### `#check_for_archived_artefact`


**See**:
- [Source on GitHub](https://github.com/alphagov/govuk_content_models/blob/master/app/models/edition.rb#L288)

### `#artefact`


**See**:
- [Source on GitHub](https://github.com/alphagov/govuk_content_models/blob/master/app/models/edition.rb#L302)

### `#destroy_artefact`

When we delete an edition is the only one in its series
we delete the associated artefact to remove all trace of the
item from the system.

We don't do this by notifying panopticon as this will only ever
happen for artefacts representing editions that haven't been
published (and therefore aren't registered in the rest of the)
system.

**See**:
- [Source on GitHub](https://github.com/alphagov/govuk_content_models/blob/master/app/models/edition.rb#L314)

---

## `class CannotEditSlugIfEverPublished`

### `#validate(record)`


**See**:
- [Source on GitHub](https://github.com/alphagov/govuk_content_models/blob/master/app/models/artefact.rb#L6)

---

## `class Artefact`

### `.default_app_for_format(format)`


**See**:
- [Source on GitHub](https://github.com/alphagov/govuk_content_models/blob/master/app/models/artefact.rb#L123)

### `.in_alphabetical_order`


**See**:
- [Source on GitHub](https://github.com/alphagov/govuk_content_models/blob/master/app/models/artefact.rb#L158)

### `.find_by_slug(s)`


**See**:
- [Source on GitHub](https://github.com/alphagov/govuk_content_models/blob/master/app/models/artefact.rb#L162)

### `#language`

Fallback to english if no language is present

**See**:
- [Source on GitHub](https://github.com/alphagov/govuk_content_models/blob/master/app/models/artefact.rb#L167)

### `#normalise`


**See**:
- [Source on GitHub](https://github.com/alphagov/govuk_content_models/blob/master/app/models/artefact.rb#L171)

### `#admin_url(options = {})`


**See**:
- [Source on GitHub](https://github.com/alphagov/govuk_content_models/blob/master/app/models/artefact.rb#L176)

### `#as_json(options={})`


**See**:
- [Source on GitHub](https://github.com/alphagov/govuk_content_models/blob/master/app/models/artefact.rb#L182)

### `#any_editions_published?`

**Returns**:

- (`Boolean`) —

**See**:
- [Source on GitHub](https://github.com/alphagov/govuk_content_models/blob/master/app/models/artefact.rb#L188)

### `#any_editions_ever_published?`

**Returns**:

- (`Boolean`) —

**See**:
- [Source on GitHub](https://github.com/alphagov/govuk_content_models/blob/master/app/models/artefact.rb#L192)

### `#update_editions`


**See**:
- [Source on GitHub](https://github.com/alphagov/govuk_content_models/blob/master/app/models/artefact.rb#L197)

### `#archive_editions`


**See**:
- [Source on GitHub](https://github.com/alphagov/govuk_content_models/blob/master/app/models/artefact.rb#L211)

### `.from_param(slug_or_id)`


**See**:
- [Source on GitHub](https://github.com/alphagov/govuk_content_models/blob/master/app/models/artefact.rb#L220)

### `#update_attributes_as(user, *args)`


**See**:
- [Source on GitHub](https://github.com/alphagov/govuk_content_models/blob/master/app/models/artefact.rb#L224)

### `#save_as(user, options={})`


**See**:
- [Source on GitHub](https://github.com/alphagov/govuk_content_models/blob/master/app/models/artefact.rb#L229)

### `#save_as_task!(task_name, options = {})`

We should use this method when performing save actions from rake tasks,
message queue consumer or any other performed tasks that have no user associated
as we are still interested to know what triggered the action.

**See**:
- [Source on GitHub](https://github.com/alphagov/govuk_content_models/blob/master/app/models/artefact.rb#L239)

### `#record_create_action`


**See**:
- [Source on GitHub](https://github.com/alphagov/govuk_content_models/blob/master/app/models/artefact.rb#L247)

### `#record_update_action`


**See**:
- [Source on GitHub](https://github.com/alphagov/govuk_content_models/blob/master/app/models/artefact.rb#L251)

### `#record_action(action_type, options={})`


**See**:
- [Source on GitHub](https://github.com/alphagov/govuk_content_models/blob/master/app/models/artefact.rb#L255)

### `#archived?`

**Returns**:

- (`Boolean`) —

**See**:
- [Source on GitHub](https://github.com/alphagov/govuk_content_models/blob/master/app/models/artefact.rb#L280)

### `#live?`

**Returns**:

- (`Boolean`) —

**See**:
- [Source on GitHub](https://github.com/alphagov/govuk_content_models/blob/master/app/models/artefact.rb#L284)

### `#snapshot`


**See**:
- [Source on GitHub](https://github.com/alphagov/govuk_content_models/blob/master/app/models/artefact.rb#L288)

### `#need_id=(new_need_id)`


**See**:
- [Source on GitHub](https://github.com/alphagov/govuk_content_models/blob/master/app/models/artefact.rb#L293)

---

## `class Downtime`

### `.for(artefact)`


**See**:
- [Source on GitHub](https://github.com/alphagov/govuk_content_models/blob/master/app/models/downtime.rb#L15)

### `#publicise?`

**Returns**:

- (`Boolean`) —

**See**:
- [Source on GitHub](https://github.com/alphagov/govuk_content_models/blob/master/app/models/downtime.rb#L19)

---

## `class GuideEdition`

### `#has_video?`

**Returns**:

- (`Boolean`) —

**See**:
- [Source on GitHub](https://github.com/alphagov/govuk_content_models/blob/master/app/models/guide_edition.rb#L12)

### `#safe_to_preview?`

**Returns**:

- (`Boolean`) —

**See**:
- [Source on GitHub](https://github.com/alphagov/govuk_content_models/blob/master/app/models/guide_edition.rb#L16)

---

## `class PlaceEdition`

### `#whole_body`


**See**:
- [Source on GitHub](https://github.com/alphagov/govuk_content_models/blob/master/app/models/place_edition.rb#L11)

---

## `class SafeHtml`

### `#validate(record)`


**See**:
- [Source on GitHub](https://github.com/alphagov/govuk_content_models/blob/master/app/validators/safe_html.rb#L15)

### `#check_struct(record, field_name, value)`


**See**:
- [Source on GitHub](https://github.com/alphagov/govuk_content_models/blob/master/app/validators/safe_html.rb#L22)

### `#check_string(record, field_name, string)`


**See**:
- [Source on GitHub](https://github.com/alphagov/govuk_content_models/blob/master/app/validators/safe_html.rb#L32)

---

## `class VideoEdition`

### `#has_video?`

**Returns**:

- (`Boolean`) —

**See**:
- [Source on GitHub](https://github.com/alphagov/govuk_content_models/blob/master/app/models/video_edition.rb#L15)

### `#whole_body`


**See**:
- [Source on GitHub](https://github.com/alphagov/govuk_content_models/blob/master/app/models/video_edition.rb#L19)

---

## `class LocalService`

### `.find_by_lgsl_code(lgsl_code)`


**See**:
- [Source on GitHub](https://github.com/alphagov/govuk_content_models/blob/master/app/models/local_service.rb#L17)

---

## `class AnswerEdition`

### `#whole_body`


**See**:
- [Source on GitHub](https://github.com/alphagov/govuk_content_models/blob/master/app/models/answer_edition.rb#L8)

---

## `class LicenceEdition`

### `#whole_body`


**See**:
- [Source on GitHub](https://github.com/alphagov/govuk_content_models/blob/master/app/models/licence_edition.rb#L17)

### `#indexable_content`


**See**:
- [Source on GitHub](https://github.com/alphagov/govuk_content_models/blob/master/app/models/licence_edition.rb#L21)

---

## `class CampaignEdition`

### `#whole_body`


**See**:
- [Source on GitHub](https://github.com/alphagov/govuk_content_models/blob/master/app/models/campaign_edition.rb#L65)

---

## `class HelpPageEdition`

### `#whole_body`


**See**:
- [Source on GitHub](https://github.com/alphagov/govuk_content_models/blob/master/app/models/help_page_edition.rb#L8)

---

## `class ProgrammeEdition`

### `#setup_default_parts`


**See**:
- [Source on GitHub](https://github.com/alphagov/govuk_content_models/blob/master/app/models/programme_edition.rb#L19)

---

## `class SlugValidator`

### `#validate_each(record, attribute, value)`

implement the method called during validation

**See**:
- [Source on GitHub](https://github.com/alphagov/govuk_content_models/blob/master/app/validators/slug_validator.rb#L3)

---

## `class SlugValidator::InstanceValidator`

### `#starts_with?(expected_prefix)`

**Returns**:

- (`Boolean`) —

**See**:
- [Source on GitHub](https://github.com/alphagov/govuk_content_models/blob/master/app/validators/slug_validator.rb#L20)

### `#ends_with?(expected_suffix)`

**Returns**:

- (`Boolean`) —

**See**:
- [Source on GitHub](https://github.com/alphagov/govuk_content_models/blob/master/app/validators/slug_validator.rb#L24)

### `#of_kind?(expected_kind)`

**Returns**:

- (`Boolean`) —

**See**:
- [Source on GitHub](https://github.com/alphagov/govuk_content_models/blob/master/app/validators/slug_validator.rb#L28)

### `#url_after_first_slash`


**See**:
- [Source on GitHub](https://github.com/alphagov/govuk_content_models/blob/master/app/validators/slug_validator.rb#L32)

### `#url_after_first_slash_is_valid_slug!`


**See**:
- [Source on GitHub](https://github.com/alphagov/govuk_content_models/blob/master/app/validators/slug_validator.rb#L36)

### `#url_parts`


**See**:
- [Source on GitHub](https://github.com/alphagov/govuk_content_models/blob/master/app/validators/slug_validator.rb#L42)

### `#valid_slug?(url_part)`

**Returns**:

- (`Boolean`) —

**See**:
- [Source on GitHub](https://github.com/alphagov/govuk_content_models/blob/master/app/validators/slug_validator.rb#L46)

---

## `class SlugValidator::DonePageValidator`

### `#applicable?`

**Returns**:

- (`Boolean`) —

**See**:
- [Source on GitHub](https://github.com/alphagov/govuk_content_models/blob/master/app/validators/slug_validator.rb#L55)

### `#validate!`


**See**:
- [Source on GitHub](https://github.com/alphagov/govuk_content_models/blob/master/app/validators/slug_validator.rb#L59)

---

## `class SlugValidator::ForeignTravelAdvicePageValidator`

### `#applicable?`

**Returns**:

- (`Boolean`) —

**See**:
- [Source on GitHub](https://github.com/alphagov/govuk_content_models/blob/master/app/validators/slug_validator.rb#L65)

### `#validate!`


**See**:
- [Source on GitHub](https://github.com/alphagov/govuk_content_models/blob/master/app/validators/slug_validator.rb#L69)

---

## `class SlugValidator::FinderEmailSignupValidator`

### `#applicable?`

**Returns**:

- (`Boolean`) —

**See**:
- [Source on GitHub](https://github.com/alphagov/govuk_content_models/blob/master/app/validators/slug_validator.rb#L75)

### `#validate!`


**See**:
- [Source on GitHub](https://github.com/alphagov/govuk_content_models/blob/master/app/validators/slug_validator.rb#L79)

---

## `class SlugValidator::HelpPageValidator`

### `#applicable?`

**Returns**:

- (`Boolean`) —

**See**:
- [Source on GitHub](https://github.com/alphagov/govuk_content_models/blob/master/app/validators/slug_validator.rb#L85)

### `#validate!`


**See**:
- [Source on GitHub](https://github.com/alphagov/govuk_content_models/blob/master/app/validators/slug_validator.rb#L89)

---

## `class SlugValidator::GovernmentPageValidator`

### `#url_parts`


**See**:
- [Source on GitHub](https://github.com/alphagov/govuk_content_models/blob/master/app/validators/slug_validator.rb#L96)

### `#applicable?`

**Returns**:

- (`Boolean`) —

**See**:
- [Source on GitHub](https://github.com/alphagov/govuk_content_models/blob/master/app/validators/slug_validator.rb#L101)

### `#validate!`


**See**:
- [Source on GitHub](https://github.com/alphagov/govuk_content_models/blob/master/app/validators/slug_validator.rb#L105)

---

## `class SlugValidator::ManualPageValidator`

### `#applicable?`

**Returns**:

- (`Boolean`) —

**See**:
- [Source on GitHub](https://github.com/alphagov/govuk_content_models/blob/master/app/validators/slug_validator.rb#L119)

### `#validate!`


**See**:
- [Source on GitHub](https://github.com/alphagov/govuk_content_models/blob/master/app/validators/slug_validator.rb#L123)

---

## `class SlugValidator::DetailedGuideValidator`

### `#applicable?`

**Returns**:

- (`Boolean`) —

**See**:
- [Source on GitHub](https://github.com/alphagov/govuk_content_models/blob/master/app/validators/slug_validator.rb#L150)

### `#validate!`


**See**:
- [Source on GitHub](https://github.com/alphagov/govuk_content_models/blob/master/app/validators/slug_validator.rb#L154)

---

## `class SlugValidator::DefaultValidator`

### `#applicable?`

**Returns**:

- (`Boolean`) —

**See**:
- [Source on GitHub](https://github.com/alphagov/govuk_content_models/blob/master/app/validators/slug_validator.rb#L160)

### `#validate!`


**See**:
- [Source on GitHub](https://github.com/alphagov/govuk_content_models/blob/master/app/validators/slug_validator.rb#L164)

---

## `class LinkValidator`

### `#validate(record)`


**See**:
- [Source on GitHub](https://github.com/alphagov/govuk_content_models/blob/master/app/validators/link_validator.rb#L4)

### `#errors(string)`


**See**:
- [Source on GitHub](https://github.com/alphagov/govuk_content_models/blob/master/app/validators/link_validator.rb#L14)

---

## `class TransactionEdition`

### `#indexable_content`


**See**:
- [Source on GitHub](https://github.com/alphagov/govuk_content_models/blob/master/app/models/transaction_edition.rb#L16)

### `#whole_body`


**See**:
- [Source on GitHub](https://github.com/alphagov/govuk_content_models/blob/master/app/models/transaction_edition.rb#L20)

---

## `class TravelAdviceEdition`

### `.fields_to_clone`

Returns the value of attribute fields_to_clone

**See**:
- [Source on GitHub](https://github.com/alphagov/govuk_content_models/blob/master/app/models/travel_advice_edition.rb#L52)

### `.fields_to_clone=(value)`

Sets the attribute fields_to_clone

**Params**:

- `value` (``) — the value to set the attribute fields_to_clone to.


**See**:
- [Source on GitHub](https://github.com/alphagov/govuk_content_models/blob/master/app/models/travel_advice_edition.rb#L52)

### `#indexable_content`


**See**:
- [Source on GitHub](https://github.com/alphagov/govuk_content_models/blob/master/app/models/travel_advice_edition.rb#L88)

### `#build_clone`


**See**:
- [Source on GitHub](https://github.com/alphagov/govuk_content_models/blob/master/app/models/travel_advice_edition.rb#L97)

### `#build_action_as(user, action_type, comment = nil)`


**See**:
- [Source on GitHub](https://github.com/alphagov/govuk_content_models/blob/master/app/models/travel_advice_edition.rb#L106)

### `#publish_as(user)`


**See**:
- [Source on GitHub](https://github.com/alphagov/govuk_content_models/blob/master/app/models/travel_advice_edition.rb#L110)

### `#previous_version`


**See**:
- [Source on GitHub](https://github.com/alphagov/govuk_content_models/blob/master/app/models/travel_advice_edition.rb#L115)

---

## `class ReviewerValidator`

### `#validate(record)`


**See**:
- [Source on GitHub](https://github.com/alphagov/govuk_content_models/blob/master/app/validators/reviewer_validator.rb#L2)

---

## `class BusinessSupportEdition`

### `#whole_body`


**See**:
- [Source on GitHub](https://github.com/alphagov/govuk_content_models/blob/master/app/models/business_support_edition.rb#L44)

---

## `class LocalTransactionEdition`

### `#valid_lgsl_code`


**See**:
- [Source on GitHub](https://github.com/alphagov/govuk_content_models/blob/master/app/models/local_transaction_edition.rb#L15)

### `#format_name`


**See**:
- [Source on GitHub](https://github.com/alphagov/govuk_content_models/blob/master/app/models/local_transaction_edition.rb#L21)

### `#search_format`


**See**:
- [Source on GitHub](https://github.com/alphagov/govuk_content_models/blob/master/app/models/local_transaction_edition.rb#L25)

### `#service`


**See**:
- [Source on GitHub](https://github.com/alphagov/govuk_content_models/blob/master/app/models/local_transaction_edition.rb#L29)

### `#whole_body`


**See**:
- [Source on GitHub](https://github.com/alphagov/govuk_content_models/blob/master/app/models/local_transaction_edition.rb#L33)

---

## `class SimpleSmartAnswerEdition`

### `#whole_body`


**See**:
- [Source on GitHub](https://github.com/alphagov/govuk_content_models/blob/master/app/models/simple_smart_answer_edition.rb#L19)

### `#build_clone(target_class=nil)`


**See**:
- [Source on GitHub](https://github.com/alphagov/govuk_content_models/blob/master/app/models/simple_smart_answer_edition.rb#L27)

### `#original_update_attributes`

Workaround mongoid conflicting mods error
See https://jira.mongodb.org/browse/MONGOID-1220
Override update_attributes so that nested nodes are updated individually.
This get around the problem of mongoid issuing a query with conflicting modifications
to the same document.

**See**:
- [Source on GitHub](https://github.com/alphagov/govuk_content_models/blob/master/app/models/simple_smart_answer_edition.rb#L43)

### `#update_attributes(attributes)`


**See**:
- [Source on GitHub](https://github.com/alphagov/govuk_content_models/blob/master/app/models/simple_smart_answer_edition.rb#L45)

### `#initial_node`


**See**:
- [Source on GitHub](https://github.com/alphagov/govuk_content_models/blob/master/app/models/simple_smart_answer_edition.rb#L64)

### `#destroy_in_attrs?(attrs)`

**Returns**:

- (`Boolean`) —

**See**:
- [Source on GitHub](https://github.com/alphagov/govuk_content_models/blob/master/app/models/simple_smart_answer_edition.rb#L68)

---

## `class CompletedTransactionEdition`

### `#whole_body`


**See**:
- [Source on GitHub](https://github.com/alphagov/govuk_content_models/blob/master/app/models/completed_transaction_edition.rb#L10)

---

## `class GovukContentModels::ActionProcessors::BaseProcessor`

### `#actor`

Returns the value of attribute actor

**See**:
- [Source on GitHub](https://github.com/alphagov/govuk_content_models/blob/master/lib/govuk_content_models/action_processors/base_processor.rb#L4)

### `#actor=(value)`

Sets the attribute actor

**Params**:

- `value` (``) — the value to set the attribute actor to.


**See**:
- [Source on GitHub](https://github.com/alphagov/govuk_content_models/blob/master/lib/govuk_content_models/action_processors/base_processor.rb#L4)

### `#edition`

Returns the value of attribute edition

**See**:
- [Source on GitHub](https://github.com/alphagov/govuk_content_models/blob/master/lib/govuk_content_models/action_processors/base_processor.rb#L4)

### `#edition=(value)`

Sets the attribute edition

**Params**:

- `value` (``) — the value to set the attribute edition to.


**See**:
- [Source on GitHub](https://github.com/alphagov/govuk_content_models/blob/master/lib/govuk_content_models/action_processors/base_processor.rb#L4)

### `#action_attributes`

Returns the value of attribute action_attributes

**See**:
- [Source on GitHub](https://github.com/alphagov/govuk_content_models/blob/master/lib/govuk_content_models/action_processors/base_processor.rb#L4)

### `#action_attributes=(value)`

Sets the attribute action_attributes

**Params**:

- `value` (``) — the value to set the attribute action_attributes to.


**See**:
- [Source on GitHub](https://github.com/alphagov/govuk_content_models/blob/master/lib/govuk_content_models/action_processors/base_processor.rb#L4)

### `#event_attributes`

Returns the value of attribute event_attributes

**See**:
- [Source on GitHub](https://github.com/alphagov/govuk_content_models/blob/master/lib/govuk_content_models/action_processors/base_processor.rb#L4)

### `#event_attributes=(value)`

Sets the attribute event_attributes

**Params**:

- `value` (``) — the value to set the attribute event_attributes to.


**See**:
- [Source on GitHub](https://github.com/alphagov/govuk_content_models/blob/master/lib/govuk_content_models/action_processors/base_processor.rb#L4)

### `#initialize(actor, edition, action_attributes={}, event_attributes={})`

**Returns**:

- (`BaseProcessor`) — a new instance of BaseProcessor

**See**:
- [Source on GitHub](https://github.com/alphagov/govuk_content_models/blob/master/lib/govuk_content_models/action_processors/base_processor.rb#L6)

### `#processed_edition`


**See**:
- [Source on GitHub](https://github.com/alphagov/govuk_content_models/blob/master/lib/govuk_content_models/action_processors/base_processor.rb#L13)

---

## `class GovukContentModels::ActionProcessors::AssignProcessor`

### `#process`


**See**:
- [Source on GitHub](https://github.com/alphagov/govuk_content_models/blob/master/lib/govuk_content_models/action_processors/assign_processor.rb#L5)

---

## `class GovukContentModels::ActionProcessors::SkipReviewProcessor`

### `#process?`

**Returns**:

- (`Boolean`) —

**See**:
- [Source on GitHub](https://github.com/alphagov/govuk_content_models/blob/master/lib/govuk_content_models/action_processors/skip_review_processor.rb#L4)

---

## `class GovukContentModels::ActionProcessors::NewVersionProcessor`

### `#process?`

**Returns**:

- (`Boolean`) —

**See**:
- [Source on GitHub](https://github.com/alphagov/govuk_content_models/blob/master/lib/govuk_content_models/action_processors/new_version_processor.rb#L5)

### `#process`


**See**:
- [Source on GitHub](https://github.com/alphagov/govuk_content_models/blob/master/lib/govuk_content_models/action_processors/new_version_processor.rb#L9)

### `#record_action?`

**Returns**:

- (`Boolean`) —

**See**:
- [Source on GitHub](https://github.com/alphagov/govuk_content_models/blob/master/lib/govuk_content_models/action_processors/new_version_processor.rb#L20)

---

## `class GovukContentModels::ActionProcessors::CreateEditionProcessor`

### `#action_name`


**See**:
- [Source on GitHub](https://github.com/alphagov/govuk_content_models/blob/master/lib/govuk_content_models/action_processors/create_edition_processor.rb#L5)

### `#process`


**See**:
- [Source on GitHub](https://github.com/alphagov/govuk_content_models/blob/master/lib/govuk_content_models/action_processors/create_edition_processor.rb#L9)

### `#record_action?`

**Returns**:

- (`Boolean`) —

**See**:
- [Source on GitHub](https://github.com/alphagov/govuk_content_models/blob/master/lib/govuk_content_models/action_processors/create_edition_processor.rb#L16)

---

## `class GovukContentModels::ActionProcessors::ApproveReviewProcessor`

### `#process?`

**Returns**:

- (`Boolean`) —

**See**:
- [Source on GitHub](https://github.com/alphagov/govuk_content_models/blob/master/lib/govuk_content_models/action_processors/approve_review_processor.rb#L5)

---

## `class GovukContentModels::ActionProcessors::SendFactCheckProcessor`

### `#process`


**See**:
- [Source on GitHub](https://github.com/alphagov/govuk_content_models/blob/master/lib/govuk_content_models/action_processors/send_fact_check_processor.rb#L5)

---

## `class GovukContentModels::ActionProcessors::RequestAmendmentsProcessor`

### `#process?`

**Returns**:

- (`Boolean`) —

**See**:
- [Source on GitHub](https://github.com/alphagov/govuk_content_models/blob/master/lib/govuk_content_models/action_processors/request_amendments_processor.rb#L5)

---

## `class GovukContentModels::ActionProcessors::ReceiveFactCheckProcessor`

### `#process`

Always records the action.

**See**:
- [Source on GitHub](https://github.com/alphagov/govuk_content_models/blob/master/lib/govuk_content_models/action_processors/receive_fact_check_processor.rb#L6)

### `#record_action?`

**Returns**:

- (`Boolean`) —

**See**:
- [Source on GitHub](https://github.com/alphagov/govuk_content_models/blob/master/lib/govuk_content_models/action_processors/receive_fact_check_processor.rb#L13)

---

## `class GovukContentModels::ActionProcessors::ScheduleForPublishingProcessor`

### `#process`


**See**:
- [Source on GitHub](https://github.com/alphagov/govuk_content_models/blob/master/lib/govuk_content_models/action_processors/schedule_for_publishing_processor.rb#L5)

---

## `module Parted`

### `#build_clone(target_class=nil)`


**See**:
- [Source on GitHub](https://github.com/alphagov/govuk_content_models/blob/master/app/models/parted.rb#L11)

### `#order_parts`


**See**:
- [Source on GitHub](https://github.com/alphagov/govuk_content_models/blob/master/app/models/parted.rb#L23)

### `#whole_body`


**See**:
- [Source on GitHub](https://github.com/alphagov/govuk_content_models/blob/master/app/models/parted.rb#L30)

---

## `module Workflow`

### `#fact_checked?`

**Returns**:

- (`Boolean`) —

**See**:
- [Source on GitHub](https://github.com/alphagov/govuk_content_models/blob/master/app/models/workflow.rb#L108)

### `#status_text`


**See**:
- [Source on GitHub](https://github.com/alphagov/govuk_content_models/blob/master/app/models/workflow.rb#L112)

### `#denormalise_users!`


**See**:
- [Source on GitHub](https://github.com/alphagov/govuk_content_models/blob/master/app/models/workflow.rb#L118)

### `#can_destroy?`

**Returns**:

- (`Boolean`) —

**See**:
- [Source on GitHub](https://github.com/alphagov/govuk_content_models/blob/master/app/models/workflow.rb#L127)

### `#check_can_delete_and_notify`


**See**:
- [Source on GitHub](https://github.com/alphagov/govuk_content_models/blob/master/app/models/workflow.rb#L131)

### `#mark_as_rejected`


**See**:
- [Source on GitHub](https://github.com/alphagov/govuk_content_models/blob/master/app/models/workflow.rb#L135)

### `#previous_edition`


**See**:
- [Source on GitHub](https://github.com/alphagov/govuk_content_models/blob/master/app/models/workflow.rb#L139)

### `#notify_siblings_of_new_edition`


**See**:
- [Source on GitHub](https://github.com/alphagov/govuk_content_models/blob/master/app/models/workflow.rb#L143)

### `#in_progress?`

**Returns**:

- (`Boolean`) —

**See**:
- [Source on GitHub](https://github.com/alphagov/govuk_content_models/blob/master/app/models/workflow.rb#L147)

### `#locked_for_edits?`

**Returns**:

- (`Boolean`) —

**See**:
- [Source on GitHub](https://github.com/alphagov/govuk_content_models/blob/master/app/models/workflow.rb#L151)

### `#error_description`


**See**:
- [Source on GitHub](https://github.com/alphagov/govuk_content_models/blob/master/app/models/workflow.rb#L155)

### `#perform_event_without_validations(event)`


**See**:
- [Source on GitHub](https://github.com/alphagov/govuk_content_models/blob/master/app/models/workflow.rb#L159)

### `#important_note`


**See**:
- [Source on GitHub](https://github.com/alphagov/govuk_content_models/blob/master/app/models/workflow.rb#L166)

---

## `module Attachable`

### `.asset_api_client`


**See**:
- [Source on GitHub](https://github.com/alphagov/govuk_content_models/blob/master/app/traits/attachable.rb#L4)

### `.asset_api_client=(api_client)`


**See**:
- [Source on GitHub](https://github.com/alphagov/govuk_content_models/blob/master/app/traits/attachable.rb#L8)

---

## `module Attachable::ClassMethods`

### `#attaches(*fields)`


**See**:
- [Source on GitHub](https://github.com/alphagov/govuk_content_models/blob/master/app/traits/attachable.rb#L13)

---

## `module Mongoid::Dirty`

### `#changes`


**See**:
- [Source on GitHub](https://github.com/alphagov/govuk_content_models/blob/master/lib/mongoid/monkey_patches.rb#L8)

---

## `module PrerenderedEntity`

### `#create_or_update_by_slug!(attributes)`


**See**:
- [Source on GitHub](https://github.com/alphagov/govuk_content_models/blob/master/app/models/prerendered_entity.rb#L2)

### `#find_by_slug(slug)`


**See**:
- [Source on GitHub](https://github.com/alphagov/govuk_content_models/blob/master/app/models/prerendered_entity.rb#L10)

---

## `module PresentationToggles`

### `#promotion_choice=(value)`


**See**:
- [Source on GitHub](https://github.com/alphagov/govuk_content_models/blob/master/lib/govuk_content_models/presentation_toggles.rb#L10)

### `#promotion_choice_url=(value)`


**See**:
- [Source on GitHub](https://github.com/alphagov/govuk_content_models/blob/master/lib/govuk_content_models/presentation_toggles.rb#L14)

### `#promotion_choice`


**See**:
- [Source on GitHub](https://github.com/alphagov/govuk_content_models/blob/master/lib/govuk_content_models/presentation_toggles.rb#L18)

### `#promotes_something?`

**Returns**:

- (`Boolean`) —

**See**:
- [Source on GitHub](https://github.com/alphagov/govuk_content_models/blob/master/lib/govuk_content_models/presentation_toggles.rb#L23)

### `#promotion_choice_url`


**See**:
- [Source on GitHub](https://github.com/alphagov/govuk_content_models/blob/master/lib/govuk_content_models/presentation_toggles.rb#L27)

### `#promotion_choice_key`


**See**:
- [Source on GitHub](https://github.com/alphagov/govuk_content_models/blob/master/lib/govuk_content_models/presentation_toggles.rb#L31)

---

## `module PresentationToggles::ClassMethods`

### `#default_presentation_toggles`


**See**:
- [Source on GitHub](https://github.com/alphagov/govuk_content_models/blob/master/lib/govuk_content_models/presentation_toggles.rb#L39)

---

## `module LocalServicesHelper`

### `#make_service(lgsl_code, providing_tier)`


**See**:
- [Source on GitHub](https://github.com/alphagov/govuk_content_models/blob/master/lib/govuk_content_models/test_helpers/local_services.rb#L2)

---

## `module GovukContentModels::TestHelpers::ActionProcessorHelpers`

### `#request_review(user, edition)`


**See**:
- [Source on GitHub](https://github.com/alphagov/govuk_content_models/blob/master/lib/govuk_content_models/test_helpers/action_processor_helpers.rb#L4)

### `#approve_review(user, edition)`


**See**:
- [Source on GitHub](https://github.com/alphagov/govuk_content_models/blob/master/lib/govuk_content_models/test_helpers/action_processor_helpers.rb#L8)

### `#send_fact_check(user, edition, comment="Fact check this guide please.")`


**See**:
- [Source on GitHub](https://github.com/alphagov/govuk_content_models/blob/master/lib/govuk_content_models/test_helpers/action_processor_helpers.rb#L12)

### `#receive_fact_check(user, edition, comment="Please verify these facts.")`


**See**:
- [Source on GitHub](https://github.com/alphagov/govuk_content_models/blob/master/lib/govuk_content_models/test_helpers/action_processor_helpers.rb#L16)

### `#approve_fact_check(user, edition, comment="No changes needed, this is all correct")`


**See**:
- [Source on GitHub](https://github.com/alphagov/govuk_content_models/blob/master/lib/govuk_content_models/test_helpers/action_processor_helpers.rb#L20)

### `#request_amendments(user, edition)`


**See**:
- [Source on GitHub](https://github.com/alphagov/govuk_content_models/blob/master/lib/govuk_content_models/test_helpers/action_processor_helpers.rb#L24)

### `#publish(user, edition, comment='Yo!')`


**See**:
- [Source on GitHub](https://github.com/alphagov/govuk_content_models/blob/master/lib/govuk_content_models/test_helpers/action_processor_helpers.rb#L28)

### `#schedule_for_publishing(user, edition, action_attributes)`


**See**:
- [Source on GitHub](https://github.com/alphagov/govuk_content_models/blob/master/lib/govuk_content_models/test_helpers/action_processor_helpers.rb#L32)

### `#skip_review(user, edition)`


**See**:
- [Source on GitHub](https://github.com/alphagov/govuk_content_models/blob/master/lib/govuk_content_models/test_helpers/action_processor_helpers.rb#L38)

---
