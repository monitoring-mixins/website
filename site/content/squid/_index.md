---
title: squid
---

## Overview



{{< panel style="danger" >}}
Jsonnet source code is available at [github.com/grafana/jsonnet-libs](https://github.com/grafana/jsonnet-libs/tree/master/squid-mixin)
{{< /panel >}}

## Alerts

{{< panel style="warning" >}}
Complete list of pregenerated alerts is available [here](https://github.com/monitoring-mixins/website/blob/master/assets/squid/alerts.yaml).
{{< /panel >}}

### squid-alerts

##### SquidHighHTTPServerRequestErrors

{{< code lang="yaml" >}}
alert: SquidHighHTTPServerRequestErrors
annotations:
  description: |
    The percentage of HTTP server request errors is {{ printf "%.0f" $value }} over the last 5m on {{ $labels.instance }} which is above the threshold of 5.
  summary: There are a high number of HTTP server errors.
expr: |
  rate(squid_server_http_errors_total[5m]) / clamp_min(rate(squid_server_http_requests_total[5m]),1) * 100 > 5
for: 5m
labels:
  severity: critical
{{< /code >}}
 
##### SquidHighFTPServerRequestErrors

{{< code lang="yaml" >}}
alert: SquidHighFTPServerRequestErrors
annotations:
  description: |
    The percentage of FTP server request errors is {{ printf "%.0f" $value }} over the last 5m on {{ $labels.instance }} which is above the threshold of 5.
  summary: There are a high number of FTP server request errors.
expr: |
  rate(squid_server_ftp_errors_total[5m]) / clamp_min(rate(squid_server_ftp_requests_total[5m]),1) * 100 > 5
for: 5m
labels:
  severity: critical
{{< /code >}}
 
##### SquidHighOtherServerRequestErrors

{{< code lang="yaml" >}}
alert: SquidHighOtherServerRequestErrors
annotations:
  description: |
    The percentage of other server request errors is {{ printf "%.0f" $value }} over the last 5m on {{ $labels.instance }} which is above the threshold of 5.
  summary: There are a high number of other server request errors.
expr: |
  rate(squid_server_other_errors_total[5m]) / clamp_min(rate(squid_server_other_requests_total[5m]),1) * 100 > 5
for: 5m
labels:
  severity: critical
{{< /code >}}
 
##### SquidHighClientRequestErrors

{{< code lang="yaml" >}}
alert: SquidHighClientRequestErrors
annotations:
  description: |
    The percentage of HTTP client request errors is {{ printf "%.0f" $value }} over the last 5m on {{ $labels.instance }} which is above the threshold of 5.
  summary: There are a high number of HTTP client request errors.
expr: |
  rate(squid_client_http_errors_total[5m]) / clamp_min(rate(squid_client_http_requests_total[5m]),1) * 100 > 5
for: 5m
labels:
  severity: critical
{{< /code >}}
 
##### SquidLowCacheHitRatio

{{< code lang="yaml" >}}
alert: SquidLowCacheHitRatio
annotations:
  description: |
    The cache hit ratio is {{ printf "%.0f" $value }} over the last 10m on {{ $labels.instance }} which is below the threshold of 85.
  summary: The cache hit ratio has fallen below the configured threshold (%).
expr: |
  rate(squid_client_http_hits_total[10m]) / clamp_min(rate(squid_client_http_requests_total[10m]),1) * 100 < 85
for: 10m
labels:
  severity: warning
{{< /code >}}
 
## Dashboards
Following dashboards are generated from mixins and hosted on github:


- [squid-logs](https://github.com/monitoring-mixins/website/blob/master/assets/squid/dashboards/squid-logs.json)
- [squid-overview](https://github.com/monitoring-mixins/website/blob/master/assets/squid/dashboards/squid-overview.json)
