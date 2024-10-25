---
title: cert-manager
---

## Overview



{{< panel style="danger" >}}
Jsonnet source code is available at [github.com/imusmanmalik/cert-manager-mixin.git](https://github.com/imusmanmalik/cert-manager-mixin.git)
{{< /panel >}}

## Alerts

{{< panel style="warning" >}}
Complete list of pregenerated alerts is available [here](https://github.com/monitoring-mixins/website/blob/master/assets/cert-manager/alerts.yaml).
{{< /panel >}}

### cert-manager

##### CertManagerAbsent

{{< code lang="yaml" >}}
alert: CertManagerAbsent
annotations:
  description: New certificates will not be able to be minted, and existing ones can't
    be renewed until cert-manager is back.
  runbook_url: https://github.com/imusmanmalik/cert-manager-mixin/blob/main/RUNBOOK.md#certmanagerabsent
  summary: Cert Manager has disappeared from Prometheus service discovery.
expr: absent(up{job="cert-manager"})
for: 10m
labels:
  severity: critical
{{< /code >}}
 
### certificates

##### CertManagerCertExpirySoon

{{< code lang="yaml" >}}
alert: CertManagerCertExpirySoon
annotations:
  dashboard_url: https://grafana.example.com/d/TvuRo2iMk/cert-manager
  description: The domain that this cert covers will be unavailable after {{ $value
    | humanizeDuration }}. Clients using endpoints that this cert protects will start
    to fail in {{ $value | humanizeDuration }}.
  runbook_url: https://github.com/imusmanmalik/cert-manager-mixin/blob/main/RUNBOOK.md#certmanagercertexpirysoon
  summary: The cert `{{ $labels.name }}` is {{ $value | humanizeDuration }} from expiry,
    it should have renewed over a week ago.
expr: |
  avg by (exported_namespace, namespace, name) (
    certmanager_certificate_expiration_timestamp_seconds - time()
  ) < (21 * 24 * 3600) # 21 days in seconds
for: 1h
labels:
  severity: warning
{{< /code >}}
 
##### CertManagerCertNotReady

{{< code lang="yaml" >}}
alert: CertManagerCertNotReady
annotations:
  dashboard_url: https://grafana.example.com/d/TvuRo2iMk/cert-manager
  description: This certificate has not been ready to serve traffic for at least 10m.
    If the cert is being renewed or there is another valid cert, the ingress controller
    _may_ be able to serve that instead.
  runbook_url: https://github.com/imusmanmalik/cert-manager-mixin/blob/main/RUNBOOK.md#certmanagercertnotready
  summary: The cert `{{ $labels.name }}` is not ready to serve traffic.
expr: |
  max by (name, exported_namespace, namespace, condition) (
    certmanager_certificate_ready_status{condition!="True"} == 1
  )
for: 10m
labels:
  severity: critical
{{< /code >}}
 
##### CertManagerHittingRateLimits

{{< code lang="yaml" >}}
alert: CertManagerHittingRateLimits
annotations:
  dashboard_url: https://grafana.example.com/d/TvuRo2iMk/cert-manager
  description: Depending on the rate limit, cert-manager may be unable to generate
    certificates for up to a week.
  runbook_url: https://github.com/imusmanmalik/cert-manager-mixin/blob/main/RUNBOOK.md#certmanagerhittingratelimits
  summary: Cert manager hitting LetsEncrypt rate limits.
expr: |
  sum by (host) (
    rate(certmanager_http_acme_client_request_count{status="429"}[5m])
  ) > 0
for: 5m
labels:
  severity: critical
{{< /code >}}
 
## Dashboards
Following dashboards are generated from mixins and hosted on github:


- [overview](https://github.com/monitoring-mixins/website/blob/master/assets/cert-manager/dashboards/overview.json)
