---
title: outagedeck
---

## Overview

Configurable Prometheus alerts and a Grafana dashboard for cloud and SaaS provider status exported by OutageDeck.

{{< panel style="danger" >}}
Jsonnet source code is available at [github.com/outagedeck/prometheus-exporter](https://github.com/outagedeck/prometheus-exporter/tree/master/mixin)
{{< /panel >}}

## Alerts

{{< panel style="warning" >}}
Complete list of pregenerated alerts is available [here](https://github.com/monitoring-mixins/website/blob/master/assets/outagedeck/alerts.yaml).
{{< /panel >}}

### outagedeck

##### OutageDeckProviderDisruption

{{< code lang="yaml" >}}
alert: OutageDeckProviderDisruption
annotations:
  description: OutageDeck provider status code is {{ $value }} for {{ $labels.provider
    }}.
  summary: '{{ $labels.name }} is reporting a service disruption'
expr: outagedeck_provider_status_code >= 3 and outagedeck_provider_status_code < 5
for: 2m
labels:
  severity: warning
{{< /code >}}

##### OutageDeckProviderMajorOutage

{{< code lang="yaml" >}}
alert: OutageDeckProviderMajorOutage
annotations:
  description: OutageDeck reports a major outage for {{ $labels.provider }}.
  summary: '{{ $labels.name }} is reporting a major outage'
expr: outagedeck_provider_status_code == 5
for: 2m
labels:
  severity: critical
{{< /code >}}

##### OutageDeckProviderStatusUnknown

{{< code lang="yaml" >}}
alert: OutageDeckProviderStatusUnknown
annotations:
  description: OutageDeck cannot currently normalize the provider status.
  summary: '{{ $labels.name }} status is unknown'
expr: outagedeck_provider_status_code == 0
for: 10m
labels:
  severity: warning
{{< /code >}}

##### OutageDeckServiceDisruption

{{< code lang="yaml" >}}
alert: OutageDeckServiceDisruption
annotations:
  description: OutageDeck service status code is {{ $value }} for {{ $labels.service
    }}.
  summary: '{{ $labels.name }} is reporting a service disruption'
expr: outagedeck_service_status_code >= 3
for: 2m
labels:
  severity: warning
{{< /code >}}

##### OutageDeckRefreshFailed

{{< code lang="yaml" >}}
alert: OutageDeckRefreshFailed
annotations:
  description: The exporter has failed to refresh this provider for the configured
    interval.
  summary: OutageDeck refresh failed for {{ $labels.provider }}
expr: outagedeck_scrape_success == 0
for: 10m
labels:
  severity: warning
{{< /code >}}

##### OutageDeckSourceDataStale

{{< code lang="yaml" >}}
alert: OutageDeckSourceDataStale
annotations:
  description: The latest official-source observation is older than the configured
    threshold.
  summary: OutageDeck source data is stale for {{ $labels.name }}
expr: outagedeck_provider_source_age_seconds > 900
for: 5m
labels:
  severity: warning
{{< /code >}}

## Dashboards
Following dashboards are generated from mixins and hosted on github:


- [outagedeck-provider-status](https://github.com/monitoring-mixins/website/blob/master/assets/outagedeck/dashboards/outagedeck-provider-status.json)
