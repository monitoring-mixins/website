---
title: blackbox_exporter
---

## Overview



{{< panel style="danger" >}}
Jsonnet source code is available at [github.com/adinhodovic/blackbox-exporter-mixin/](https://github.com/adinhodovic/blackbox-exporter-mixin/)
{{< /panel >}}

## Alerts

{{< panel style="warning" >}}
Complete list of pregenerated alerts is available [here](https://github.com/monitoring-mixins/website/blob/master/assets/blackbox_exporter/alerts.yaml).
{{< /panel >}}

### blackbox-exporter.rules

##### BlackboxProbeFailed

{{< code lang="yaml" >}}
alert: BlackboxProbeFailed
annotations:
  dashboard_url: https://grafana.com/d/blackbox-exporter-j4da/blackbox-exporter?var-instance={{
    $labels.instance }}
  description: The probe failed for the instance {{ $labels.instance }}.
  summary: Probe has failed for the past 1m interval.
expr: |
  probe_success{job="blackbox-exporter"} == 0
for: 1m
labels:
  severity: critical
{{< /code >}}
 
##### BlackboxLowUptime30d

{{< code lang="yaml" >}}
alert: BlackboxLowUptime30d
annotations:
  dashboard_url: https://grafana.com/d/blackbox-exporter-j4da/blackbox-exporter?var-instance={{
    $labels.instance }}
  description: The probe has a lower uptime than 99.9% the last 30 days for the instance
    {{ $labels.instance }}.
  summary: Probe uptime is lower than 99.9% for the last 30 days.
expr: |
  avg_over_time(probe_success{job="blackbox-exporter"}[30d]) * 100 < 99.900000000000006
labels:
  severity: info
{{< /code >}}
 
##### BlackboxSslCertificateWillExpireSoon

{{< code lang="yaml" >}}
alert: BlackboxSslCertificateWillExpireSoon
annotations:
  dashboard_url: https://grafana.com/d/blackbox-exporter-j4da/blackbox-exporter?var-instance={{
    $labels.instance }}
  description: |
    The SSL certificate of the instance {{ $labels.instance }} is expiring within 21 days.
    Actual time left: {{ $value | humanizeDuration }}.
  summary: SSL certificate will expire soon.
expr: |
  probe_ssl_earliest_cert_expiry{job="blackbox-exporter"} - time() < 21 * 24 * 3600
labels:
  severity: warning
{{< /code >}}
 
## Dashboards
Following dashboards are generated from mixins and hosted on github:


- [blackbox-exporter](https://github.com/monitoring-mixins/website/blob/master/assets/blackbox_exporter/dashboards/blackbox-exporter.json)
