---
title: asterisk
---

## Overview



{{< panel style="danger" >}}
Jsonnet source code is available at [github.com/grafana/jsonnet-libs](https://github.com/grafana/jsonnet-libs/tree/master/asterisk-mixin)
{{< /panel >}}

## Alerts

{{< panel style="warning" >}}
Complete list of pregenerated alerts is available [here](https://github.com/monitoring-mixins/website/blob/master/assets/asterisk/alerts.yaml).
{{< /panel >}}

### AsteriskAlerts

##### AsteriskRestarted

{{< code lang="yaml" >}}
alert: AsteriskRestarted
annotations:
  description: |-
    Asterisk instance restarted in the last minute
      VALUE = {{ $value }}
      LABELS = {{ $labels }}
  summary: Asterisk instance restarted in the last minute.
expr: asterisk_core_uptime_seconds < 60
for: 5s
labels:
  severity: critical
{{< /code >}}
 
##### AsteriskReloaded

{{< code lang="yaml" >}}
alert: AsteriskReloaded
annotations:
  description: |-
    Asterisk instance reloaded in the last minute
      VALUE = {{ $value }}
      LABELS = {{ $labels }}
  summary: Asterisk instance reloaded in the last minute.
expr: asterisk_core_last_reload_seconds < 60
for: 5s
labels:
  severity: warning
{{< /code >}}
 
##### AsteriskHighScrapeTime

{{< code lang="yaml" >}}
alert: AsteriskHighScrapeTime
annotations:
  description: |-
    Asterisk instance core high scrape time (Possible system performance degradation)
      VALUE = {{ $value }}
      LABELS = {{ $labels }}
  summary: Asterisk instance core high scrape time.
expr: asterisk_core_scrape_time_ms > 100
for: 10s
labels:
  severity: critical
{{< /code >}}
 
##### AsteriskHighActiveCallsCount

{{< code lang="yaml" >}}
alert: AsteriskHighActiveCallsCount
annotations:
  description: |-
    Asterisk high active call count
      VALUE = {{ $value }}
      LABELS = {{ $labels }}
  summary: Asterisk high active call count.
expr: asterisk_calls_count > 100
for: 10s
labels:
  severity: warning
{{< /code >}}
 
## Dashboards
Following dashboards are generated from mixins and hosted on github:


- [asterisk-logs](https://github.com/monitoring-mixins/website/blob/master/assets/asterisk/dashboards/asterisk-logs.json)
- [asterisk-overview](https://github.com/monitoring-mixins/website/blob/master/assets/asterisk/dashboards/asterisk-overview.json)
