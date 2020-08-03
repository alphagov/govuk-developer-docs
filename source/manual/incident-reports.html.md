---
owner_slack: "@nila.patel"
title: Write an incident report
parent: "/manual.html"
layout: manual_layout
section: Incidents
---

This page is for reference only. Use the [incident report template][tpl] on Google Drive when drafting the report.

[tpl]: https://docs.google.com/document/d/1YDA13RU6wicXoKgDv5VucJe3o_Z0k_Qhug9EJC_XdSE/edit

## Incident report checklist:

* Ensure you make a copy of this document and edit the copy.
* Read the [guidance for what to do if you are comms lead](https://docs.google.com/document/d/1ty12B5eBWB9YSfnD9xY1mr5rtTQxdNxRdmEGgibilN0/edit).
* Share this report with the GOV.UK Incident Google mailing list as soon as possible.
* Make it clear that it’s a draft version.
* Include as much information as possible and a draft root cause ahead of the review.  
* Ensure this document is viewable to anyone with a GDS email account.

## Incident report

```
Start Date|YYYY-MM-DD
----------|----------
End Date|YYYY-MM-DD
Start Time|HH:MM (local time)
End Time|HH:MM (local time)
Application / process|
Priority|Was it a P1, P2, P3, or P4 incident?
Incident lead| 2nd line primary engineer or a senior developer
Comms lead|2nd line secondary engineer

Overview

_[Provide a summary here]_

User impact (external/internal)

_[Detail of the specific front-end user impact]_

Services affected and/or Departmental impact

_[Detail of the specific departmental/publisher impact]_

Timeline
All times in 24-hour (e.g. 16:12) local time, unless otherwise stated.

Time|Description
----|-----------
HH:MM|
Total duration of incident (time from when problem started to incident marked as resolved)|
Time to fix (time from when incident declared to marked as resolved)|
```

## Incident Review

### Date:

### Time:

### Attendance:

### Root cause analysis

A root cause is an underlying factor why an incident occurred, which when fixed would prevent a recurrence. Identify and summarise all of the root causes that led to the incident in a short paragraph, aimed at a non-technical audience.

Reference all root cause categories that apply, for instance;

* Unexpected effect of code change
* Configuration fault (configuration change, pre-existing fault, etc)
* Capacity issue (insufficient capacity to meet demand, implementation issue, etc)
* Provider / third-party infrastructure failure (hardware, network failure, etc)
* Workflow issue (usability issue, misoperation, etc)
* Software design / architecture problem (i.e. worked as designed but led to a problem)
* Other (please specify)

...

### Actions

Use this section to assign actions to individuals (not teams). These are actions to be taken to fix the root cause of the issue, for preventative measures and for any other improvements.

* ...

### Standing actions

* Update your incident log with incident title, priority, dates/times and a link to this report.
* Present a summary of this incident to your team to share learning.
* Coordinate a blogpost - if applicable

### Recommendations

* ...

### Considerations

Some questions to consider when writing the Incident Report and whilst working on RCA.

* What caused the original issue to occur?
* Why was this not caught before it reached production, if applicable?
* Were we alerted quickly?
* Were we able to diagnose and fix the immediate issue quickly?
* Has the underlying issue been fixed?, if not how do we prevent a recurrence?
* What other fixes/changes have been taken or need to take place as a result, if any?
* What things helped during the incident?
* What things hindered during the incident?
* Was the process followed well and were comms effective?
* What could we do to improve our response and comms process?

### Notes

Use this section to add notes during the incident management process.
