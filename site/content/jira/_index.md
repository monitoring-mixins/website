---
title: jira
---

## Overview



{{< panel style="danger" >}}
Jsonnet source code is available at [github.com/grafana/jsonnet-libs](https://github.com/grafana/jsonnet-libs/tree/master/jira-mixin)
{{< /panel >}}

## Alerts

{{< panel style="warning" >}}
Complete list of pregenerated alerts is available [here](https://github.com/monitoring-mixins/website/blob/master/assets/jira/alerts.yaml).
{{< /panel >}}

### alert.rules

##### LicenseExpired

{{< code lang="yaml" >}}
alert: LicenseExpired
annotations:
  description: The JIRA license has expired.
  summary: JIRA license expired.
expr: jira_license_expiry_days_gauge <= 0
for: 1m
labels:
  severity: critical
{{< /code >}}
 
##### LicenseWarning

{{< code lang="yaml" >}}
alert: LicenseWarning
annotations:
  description: The JIRA license will expire in less than one week.
  summary: License expiring soon.
expr: jira_license_expiry_days_gauge <= 7 and jira_license_expiry_days_gauge > 0
for: 1m
labels:
  severity: warning
{{< /code >}}
 
##### NoUserCapacity

{{< code lang="yaml" >}}
alert: NoUserCapacity
annotations:
  description: There is no more capacity for additional users to be added to the system.
  summary: All available accounts are taken.
expr: jira_all_users_gauge/jira_allowed_users_gauge == 1
for: 1m
labels:
  severity: critical
{{< /code >}}
 
##### EmailErrorsHigh

{{< code lang="yaml" >}}
alert: EmailErrorsHigh
annotations:
  description: More than 1% of emails have resulted in an error in the past minute.
  summary: Email errors are high.
expr: jira_mail_queue_error_gauge /jira_mail_queue_gauge > 0.01
for: 1m
labels:
  severity: critical
{{< /code >}}
 
## Dashboards
Following dashboards are generated from mixins and hosted on github:


- [jira-overview](https://github.com/monitoring-mixins/website/blob/master/assets/jira/dashboards/jira-overview.json)
