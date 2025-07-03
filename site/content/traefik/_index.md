---
title: traefik
---

## Overview



{{< panel style="danger" >}}
Jsonnet source code is available at [github.com/grafana/jsonnet-libs](https://github.com/grafana/jsonnet-libs/tree/master/traefik-mixin)
{{< /panel >}}

## Alerts

{{< panel style="warning" >}}
Complete list of pregenerated alerts is available [here](https://github.com/monitoring-mixins/website/blob/master/assets/traefik/alerts.yaml).
{{< /panel >}}

### traefik

##### TraefikConfigReloadFailuresIncreasing

{{< code lang="yaml" >}}
alert: TraefikConfigReloadFailuresIncreasing
annotations:
  description: |
    Traefik is failing to reload its config in {{ $labels.job }}.
  summary: Traefik is failing to reload its configuration.
expr: |
  sum by (job) (rate(traefik_config_reloads_failure_total{}[5m])) > 0
for: 5m
labels:
  severity: critical
{{< /code >}}
 
##### TraefikTLSCertificatesExpiring

{{< code lang="yaml" >}}
alert: TraefikTLSCertificatesExpiring
annotations:
  description: |
    The minimum number of days until a Traefik-served certificate expires is {{ printf "%.0f" $value }} days on {{ $labels.sans }} which is below the critical threshold of 7.
  summary: A Traefik-served TLS certificate will expire very soon.
expr: |
  max by (instance, sans) ((last_over_time(traefik_tls_certs_not_after{}[5m]) - time()) / 86400) < 7
for: 5m
labels:
  severity: critical
{{< /code >}}
 
##### TraefikTLSCertificatesExpiringSoon

{{< code lang="yaml" >}}
alert: TraefikTLSCertificatesExpiringSoon
annotations:
  description: |
    The minimum number of days until a Traefik-served certificate expires is {{ printf "%.0f" $value }} days on {{ $labels.sans }} which is less than 14 but greater than 7.
  summary: A Traefik-served TLS certificate will expire soon.
expr: |
  max by (instance, sans) ((last_over_time(traefik_tls_certs_not_after{}[5m]) - time()) / 86400) < 14 > 7
for: 5m
labels:
  severity: warning
{{< /code >}}
 
## Dashboards
Following dashboards are generated from mixins and hosted on github:


- [traefikdash](https://github.com/monitoring-mixins/website/blob/master/assets/traefik/dashboards/traefikdash.json)
