---
title: envoy-2
---

## Overview



{{< panel style="danger" >}}
Jsonnet source code is available at [github.com/adinhodovic/envoy-mixin](https://github.com/adinhodovic/envoy-mixin)
{{< /panel >}}

## Alerts

{{< panel style="warning" >}}
Complete list of pregenerated alerts is available [here](https://github.com/monitoring-mixins/website/blob/master/assets/envoy-2/alerts.yaml).
{{< /panel >}}

### envoy

##### EnvoyUpstreamHighHttp4xxErrorRate

{{< code lang="yaml" >}}
alert: EnvoyUpstreamHighHttp4xxErrorRate
annotations:
  dashboard_url: https://grafana.com/d/envoy-upstream-skj2/envoy-upstream?var-namespace={{
    $labels.namespace }}&var-envoy_cluster_name={{ $labels.envoy_cluster_name }}
  description: More than 5% HTTP requests with status 4xx for cluster {{ $labels.envoy_cluster_name
    }} in {{ $labels.namespace }} the past 5m.
  summary: Envoy upstream high HTTP 4xx error rate.
expr: |
  (
    sum(
      rate(
        envoy_cluster_upstream_rq_xx{
          job=~".*",
          envoy_response_code_class="4",
          envoy_cluster_name!~""
        }[5m]
      )
    ) by (cluster, namespace, envoy_cluster_name)
    /
    sum(
      rate(
        envoy_cluster_upstream_rq_total{
          job=~".*",
          envoy_cluster_name!~""
        }[5m]
      )
    ) by (cluster, namespace, envoy_cluster_name)
    * 100
  ) > 5
  and
  sum(
    rate(
      envoy_cluster_upstream_rq_xx{
        job=~".*",
        envoy_response_code_class="4",
        envoy_cluster_name!~""
      }[5m]
    )
  ) by (cluster, namespace, envoy_cluster_name)
  > 5
for: 1m
labels:
  severity: info
{{< /code >}}
 
##### EnvoyUpstreamHighHttp5xxErrorRate

{{< code lang="yaml" >}}
alert: EnvoyUpstreamHighHttp5xxErrorRate
annotations:
  dashboard_url: https://grafana.com/d/envoy-upstream-skj2/envoy-upstream?var-namespace={{
    $labels.namespace }}&var-envoy_cluster_name={{ $labels.envoy_cluster_name }}
  description: More than 5% HTTP requests with status 5xx for cluster {{ $labels.envoy_cluster_name
    }} in {{ $labels.namespace }} the past 5m.
  summary: Envoy upstream high HTTP 5xx error rate.
expr: |
  (
    sum(
      rate(
        envoy_cluster_upstream_rq_xx{
          job=~".*",
          envoy_response_code_class="5",
          envoy_cluster_name!~""
        }[5m]
      )
    ) by (cluster, namespace, envoy_cluster_name)
    /
    sum(
      rate(
        envoy_cluster_upstream_rq_total{
          job=~".*",
          envoy_cluster_name!~""
        }[5m]
      )
    ) by (cluster, namespace, envoy_cluster_name)
    * 100
  ) > 5
  and
  sum(
    rate(
      envoy_cluster_upstream_rq_xx{
        job=~".*",
        envoy_response_code_class="5",
        envoy_cluster_name!~""
      }[5m]
    )
  ) by (cluster, namespace, envoy_cluster_name)
  > 5
for: 1m
labels:
  severity: critical
{{< /code >}}
 
##### EnvoyCircuitBreakerOpen

{{< code lang="yaml" >}}
alert: EnvoyCircuitBreakerOpen
annotations:
  dashboard_url: https://grafana.com/d/envoy-upstream-skj2/envoy-upstream?var-namespace={{
    $labels.namespace }}&var-envoy_cluster_name={{ $labels.envoy_cluster_name }}
  description: Circuit breaker is open for cluster {{ $labels.envoy_cluster_name }}
    in {{ $labels.namespace }} for the past 5m.
  summary: Envoy circuit breaker is open.
expr: |
  sum(
    (
      envoy_cluster_circuit_breakers_default_rq_open{
        job=~".*",
        envoy_cluster_name!~""
      }
      or
      envoy_cluster_circuit_breakers_default_cx_open{
        job=~".*",
        envoy_cluster_name!~""
      }
      or
      envoy_cluster_circuit_breakers_default_cx_pool_open{
        job=~".*",
        envoy_cluster_name!~""
      }
    )
  ) by (cluster, namespace, envoy_cluster_name) > 0
for: 5m
labels:
  severity: warning
{{< /code >}}
 
##### EnvoyUpstreamConnectionFailures

{{< code lang="yaml" >}}
alert: EnvoyUpstreamConnectionFailures
annotations:
  dashboard_url: https://grafana.com/d/envoy-upstream-skj2/envoy-upstream?var-namespace={{
    $labels.namespace }}&var-envoy_cluster_name={{ $labels.envoy_cluster_name }}
  description: More than 100 connection failures for cluster {{ $labels.envoy_cluster_name
    }} in {{ $labels.namespace }} the past 5m.
  summary: Envoy upstream connection failures detected.
expr: |
  sum(
    increase(
      envoy_cluster_upstream_cx_connect_fail{
        job=~".*",
        envoy_cluster_name!~""
      }[5m]
    )
  ) by (cluster, namespace, envoy_cluster_name)
  > 100
for: 10m
labels:
  severity: warning
{{< /code >}}
 
##### EnvoyUpstreamUnhealthyHosts

{{< code lang="yaml" >}}
alert: EnvoyUpstreamUnhealthyHosts
annotations:
  dashboard_url: https://grafana.com/d/envoy-upstream-skj2/envoy-upstream?var-namespace={{
    $labels.namespace }}&var-envoy_cluster_name={{ $labels.envoy_cluster_name }}
  description: More than 33% of hosts are unhealthy for cluster {{ $labels.envoy_cluster_name
    }} in {{ $labels.namespace }} for the past 5m.
  summary: Envoy upstream has unhealthy hosts.
expr: |
  (
    sum(
      envoy_cluster_membership_total{
        job=~".*",
        envoy_cluster_name!~""
      }
    ) by (cluster, namespace, envoy_cluster_name)
    -
    sum(
      envoy_cluster_membership_healthy{
        job=~".*",
        envoy_cluster_name!~""
      }
    ) by (cluster, namespace, envoy_cluster_name)
  )
  /
  sum(
    envoy_cluster_membership_total{
      job=~".*",
      envoy_cluster_name!~""
    }
  ) by (cluster, namespace, envoy_cluster_name)
  * 100
  > 33
for: 5m
labels:
  severity: warning
{{< /code >}}
 
##### EnvoyXDSUpdateFailed

{{< code lang="yaml" >}}
alert: EnvoyXDSUpdateFailed
annotations:
  dashboard_url: https://grafana.com/d/envoy-gateway-overview-skj2/envoy-gateway-overview?var-namespace={{
    $labels.namespace }}
  description: XDS snapshot update failed for node {{ $labels.nodeID }} in {{ $labels.namespace
    }} with status {{ $labels.status }} the past 5m.
  summary: Envoy Gateway XDS snapshot update failed.
expr: |
  sum(
    increase(
      xds_snapshot_update_total{
        job=~".*",
        status!="success"
      }[5m]
    )
  ) by (cluster, namespace, status, nodeID)
  > 0
for: 1m
labels:
  severity: warning
{{< /code >}}
 
## Dashboards
Following dashboards are generated from mixins and hosted on github:


- [envoy-downstream](https://github.com/monitoring-mixins/website/blob/master/assets/envoy-2/dashboards/envoy-downstream.json)
- [envoy-gateway-overview](https://github.com/monitoring-mixins/website/blob/master/assets/envoy-2/dashboards/envoy-gateway-overview.json)
- [envoy-overview](https://github.com/monitoring-mixins/website/blob/master/assets/envoy-2/dashboards/envoy-overview.json)
- [envoy-upstream](https://github.com/monitoring-mixins/website/blob/master/assets/envoy-2/dashboards/envoy-upstream.json)
