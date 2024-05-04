---
title: varnish
---

## Overview



{{< panel style="danger" >}}
Jsonnet source code is available at [github.com/grafana/jsonnet-libs](https://github.com/grafana/jsonnet-libs/tree/master/varnish-mixin)
{{< /panel >}}

## Alerts

{{< panel style="warning" >}}
Complete list of pregenerated alerts is available [here](https://github.com/monitoring-mixins/website/blob/master/assets/varnish/alerts.yaml).
{{< /panel >}}

### varnish-cache

##### VarnishCacheLowCacheHitRate

{{< code lang="yaml" >}}
alert: VarnishCacheLowCacheHitRate
annotations:
  description: The Cache hit rate is {{ printf "%.0f" $value }} percent over the last
    5 minutes on {{$labels.instance}}, which is below the threshold of 80 percent.
  summary: Cache is not answering a sufficient percentage of read requests.
expr: |
  increase(varnish_main_cache_hit[10m]) / (clamp_min((increase(varnish_main_cache_hit[10m]) + increase(varnish_main_cache_miss[10m])), 1)) * 100 < 80 and (increase(varnish_main_cache_hit[10m]) + increase(varnish_main_cache_miss[10m]) > 0)
for: 10m
labels:
  severity: warning
{{< /code >}}
 
##### VarnishCacheHighMemoryUsage

{{< code lang="yaml" >}}
alert: VarnishCacheHighMemoryUsage
annotations:
  description: Current Memory Usage is {{ printf "%.0f" $value }} percent on {{$labels.instance}},
    which is above the threshold of 90 percent.
  summary: Varnish Cache is running low on available memory.
expr: |
  (varnish_sma_g_bytes{type="s0"} / (varnish_sma_g_bytes{type="s0"} + varnish_sma_g_space{type="s0"})) * 100 > 90
for: 5m
labels:
  severity: warning
{{< /code >}}
 
##### VarnishCacheHighCacheEvictionRate

{{< code lang="yaml" >}}
alert: VarnishCacheHighCacheEvictionRate
annotations:
  description: The Cache has evicted {{ printf "%.0f" $value }} objects over the last
    5 minutes on {{$labels.instance}}, which is above the threshold of 0.
  summary: The cache is evicting too many objects.
expr: |
  increase(varnish_main_n_lru_nuked[5m]) > 0
for: 5m
labels:
  severity: critical
{{< /code >}}
 
##### VarnishCacheHighSaturation

{{< code lang="yaml" >}}
alert: VarnishCacheHighSaturation
annotations:
  description: The thread queue length is {{ printf "%.0f" $value }} over the last
    5 minutes on {{$labels.instance}}, which is above the threshold of 0.
  summary: There are too many threads in queue, Varnish is saturated and responses
    are slowed.
expr: |
  varnish_main_thread_queue_len > 0
for: 5m
labels:
  severity: warning
{{< /code >}}
 
##### VarnishCacheSessionsDropping

{{< code lang="yaml" >}}
alert: VarnishCacheSessionsDropping
annotations:
  description: The amount of sessions dropped is {{ printf "%.0f" $value }} over the
    last 5 minutes on {{$labels.instance}}, which is above the threshold of 0.
  summary: Incoming requests are being dropped due to a lack of free worker threads.
expr: |
  increase(varnish_main_sessions{type="dropped"}[5m]) > 0
for: 5m
labels:
  severity: critical
{{< /code >}}
 
##### VarnishCacheBackendUnhealthy

{{< code lang="yaml" >}}
alert: VarnishCacheBackendUnhealthy
annotations:
  description: The amount of unhealthy backend statuses detected is {{ printf "%.0f"
    $value }} over the last 5 minutes on {{$labels.instance}}, which is above the
    threshold of 0.
  summary: Backend has been marked as unhealthy due to slow 200 responses.
expr: |
  increase(varnish_main_backend_unhealthy[5m]) > 0
for: 5m
labels:
  severity: critical
{{< /code >}}
 
## Dashboards
Following dashboards are generated from mixins and hosted on github:


- [varnish-overview](https://github.com/monitoring-mixins/website/blob/master/assets/varnish/dashboards/varnish-overview.json)
