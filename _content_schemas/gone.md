---
layout: content_schema
title:  Gone
---

## Publisher content schema

This is what publisher apps send to the publishing-api.

[Schema on GitHub](https://raw.githubusercontent.com/alphagov/govuk-content-schemas/master/dist/formats/gone/publisher_v2/schema.json)

<table class='schema-table'><tr><td><strong>base_path</strong> <code>string</code></td> <td></td></tr>
<tr><td><strong>content_id</strong> <code>string</code></td> <td></td></tr>
<tr><td><strong>details</strong> <code>object</code></td> <td><table class='schema-table'><tr><td><strong>explanation</strong> <code>["string", "null"]</code></td> <td></td></tr>
<tr><td><strong>alternative_path</strong> <code>["string", "null"]</code></td> <td></td></tr></table></td></tr>
<tr><td><strong>document_type</strong> </td> <td>Allowed values: <code>gone</code></td></tr>
<tr><td><strong>format</strong> </td> <td>Allowed values: <code>gone</code>DEPRECATED. This field will be removed by Tijmen.</td></tr>
<tr><td><strong>public_updated_at</strong> <code>string</code></td> <td></td></tr>
<tr><td><strong>publishing_app</strong> <code>string</code></td> <td></td></tr>
<tr><td><strong>routes</strong> <code>array</code></td> <td></td></tr>
<tr><td><strong>schema_name</strong> </td> <td>Allowed values: <code>gone</code></td></tr>
<tr><td><strong>update_type</strong> </td> <td>Allowed values: <code>major</code> or <code>minor</code> or <code>republish</code></td></tr></table>



---

## Publisher links schema

The links for this item.

[Schema on GitHub](https://raw.githubusercontent.com/alphagov/govuk-content-schemas/master/dist/formats/gone/publisher_v2/links.json)



---

## Frontend schema

This is the schema for what you'll get back from the content-store.

[Schema on GitHub](https://raw.githubusercontent.com/alphagov/govuk-content-schemas/master/dist/formats/gone/frontend/schema.json)

<table class='schema-table'><tr><td><strong>base_path</strong> <code>string</code></td> <td></td></tr>
<tr><td><strong>content_id</strong> <code>string</code></td> <td></td></tr>
<tr><td><strong>details</strong> <code>object</code></td> <td><table class='schema-table'><tr><td><strong>explanation</strong> <code>["string", "null"]</code></td> <td></td></tr>
<tr><td><strong>alternative_path</strong> <code>["string", "null"]</code></td> <td></td></tr></table></td></tr>
<tr><td><strong>document_type</strong> </td> <td>Allowed values: <code>gone</code></td></tr>
<tr><td><strong>format</strong> </td> <td>Allowed values: <code>gone</code>DEPRECATED. This field will be removed by Tijmen.</td></tr>
<tr><td><strong>public_updated_at</strong> <code>string</code></td> <td></td></tr>
<tr><td><strong>publishing_app</strong> <code>string</code></td> <td></td></tr>
<tr><td><strong>routes</strong> <code>array</code></td> <td></td></tr>
<tr><td><strong>schema_name</strong> </td> <td>Allowed values: <code>gone</code></td></tr>
<tr><td><strong>update_type</strong> </td> <td>Allowed values: <code>major</code> or <code>minor</code> or <code>republish</code></td></tr></table>

---

## Frontend examples


### gone.json
```json
{
	"base_path": "/government/case-studies/intellectual-property-stuart-scott",
	"content_id": "9931e16e-5729-41a9-830a-88613775eee0",
	"document_type": "gone",
	"publishing_app": "whitehall",
	"schema_name": "gone",
	"routes": [
		{
			"path": "/government/case-studies/intellectual-property-stuart-scott",
			"type": "exact"
		}
	],
	"details": {
		"explanation": "<div class=\"govspeak\"><p>Incorrect title</p> </div>",
		"alternative_path": ""
	}
}

```

### gone_with_alternative_path.json
```json
{
	"base_path": "/government/case-studies/intellectual-property-stuart-scotty",
	"content_id": "0931e16e-5729-41a9-830a-88613775eee0",
	"document_type": "gone",
	"publishing_app": "whitehall",
	"schema_name": "gone",
	"routes": [
		{
			"path": "/government/case-studies/intellectual-property-stuart-scotty",
			"type": "exact"
		}
	],
	"details": {
		"explanation": "<div class=\"govspeak\"><p>Incorrect title</p> </div>",
		"alternative_path": "/government/example"
	}
}

```



