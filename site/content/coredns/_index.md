---
title: coredns
---

## Overview

CoreDNS mixin provides Grafana dashboard and Prometheus Alerts to monitor CoreDNS. The mixin was introduced in [Kubernetes Node Local DNS Cache blogpost](https://povilasv.me/kubernetes-node-local-dns-cache/) to better help users monitor CoreDNS in Kubernetes. Mixin can also be used to monitor standalone CoreDNS instance without any orchestrators.

{{< panel style="danger" >}}
Jsonnet source code is available at [github.com/povilasv/coredns-mixin](https://github.com/povilasv/coredns-mixin)
{{< /panel >}}

## Alerts

{{< panel style="warning" >}}
Complete list of pregenerated alerts is available [here](https://github.com/monitoring-mixins/website/blob/master/assets/coredns/alerts.yaml).
{{< /panel >}}

### coredns

##### CoreDNSDown
https://github.com/povilasv/coredns-mixin/tree/master/runbook.md#alert-name-corednsdown

{{< code lang="yaml" >}}
alert: CoreDNSDown
annotations:
  description: CoreDNS has disappeared from Prometheus target discovery.
  runbook_url: https://github.com/povilasv/coredns-mixin/tree/master/runbook.md#alert-name-corednsdown
  summary: CoreDNS has disappeared from Prometheus target discovery.
expr: |
  absent(up{job="kube-dns"} == 1)
for: 15m
labels:
  severity: critical
{{< /code >}}
 
##### CoreDNSLatencyHigh
https://github.com/povilasv/coredns-mixin/tree/master/runbook.md#alert-name-corednslatencyhigh

{{< code lang="yaml" >}}
alert: CoreDNSLatencyHigh
annotations:
  description: CoreDNS has 99th percentile latency of {{ $value }} seconds for server
    {{ $labels.server }} zone {{ $labels.zone }} .
  runbook_url: https://github.com/povilasv/coredns-mixin/tree/master/runbook.md#alert-name-corednslatencyhigh
  summary: CoreDNS is experiencing high 99th percentile latency.
expr: |
  histogram_quantile(0.99, sum(rate(coredns_dns_request_duration_seconds_bucket{job="kube-dns"}[5m])) without (instance,pod)) > 4
for: 10m
labels:
  severity: critical
{{< /code >}}
 
##### CoreDNSErrorsHigh
https://github.com/povilasv/coredns-mixin/tree/master/runbook.md#alert-name-corednserrorshigh

{{< code lang="yaml" >}}
alert: CoreDNSErrorsHigh
annotations:
  description: CoreDNS is returning SERVFAIL for {{ $value | humanizePercentage }}
    of requests.
  runbook_url: https://github.com/povilasv/coredns-mixin/tree/master/runbook.md#alert-name-corednserrorshigh
  summary: CoreDNS is returning SERVFAIL.
expr: |
  sum without (pod, instance, server, zone, view, rcode, plugin) (rate(coredns_dns_responses_total{job="kube-dns",rcode="SERVFAIL"}[5m]))
    /
  sum without (pod, instance, server, zone, view, rcode, plugin) (rate(coredns_dns_responses_total{job="kube-dns"}[5m])) > 0.03
for: 10m
labels:
  severity: critical
{{< /code >}}
 
##### CoreDNSErrorsHigh
https://github.com/povilasv/coredns-mixin/tree/master/runbook.md#alert-name-corednserrorshigh

{{< code lang="yaml" >}}
alert: CoreDNSErrorsHigh
annotations:
  description: CoreDNS is returning SERVFAIL for {{ $value | humanizePercentage }}
    of requests.
  runbook_url: https://github.com/povilasv/coredns-mixin/tree/master/runbook.md#alert-name-corednserrorshigh
  summary: CoreDNS is returning SERVFAIL.
expr: |
  sum without (pod, instance, server, zone, view, rcode, plugin) (rate(coredns_dns_responses_total{job="kube-dns",rcode="SERVFAIL"}[5m]))
    /
  sum without (pod, instance, server, zone, view, rcode, plugin) (rate(coredns_dns_responses_total{job="kube-dns"}[5m])) > 0.01
for: 10m
labels:
  severity: warning
{{< /code >}}
 
### coredns_forward

##### CoreDNSForwardLatencyHigh
https://github.com/povilasv/coredns-mixin/tree/master/runbook.md#alert-name-corednsforwardlatencyhigh

{{< code lang="yaml" >}}
alert: CoreDNSForwardLatencyHigh
annotations:
  description: CoreDNS has 99th percentile latency of {{ $value }} seconds forwarding
    requests to {{ $labels.to }}.
  runbook_url: https://github.com/povilasv/coredns-mixin/tree/master/runbook.md#alert-name-corednsforwardlatencyhigh
  summary: CoreDNS is experiencing high latency forwarding requests.
expr: |
  histogram_quantile(0.99, sum(rate(coredns_forward_request_duration_seconds_bucket{job="kube-dns"}[5m])) without (pod, instance, rcode)) > 4
for: 10m
labels:
  severity: critical
{{< /code >}}
 
##### CoreDNSForwardErrorsHigh
https://github.com/povilasv/coredns-mixin/tree/master/runbook.md#alert-name-corednsforwarderrorshigh

{{< code lang="yaml" >}}
alert: CoreDNSForwardErrorsHigh
annotations:
  description: CoreDNS is returning SERVFAIL for {{ $value | humanizePercentage }}
    of forward requests to {{ $labels.to }}.
  runbook_url: https://github.com/povilasv/coredns-mixin/tree/master/runbook.md#alert-name-corednsforwarderrorshigh
  summary: CoreDNS is returning SERVFAIL for forward requests.
expr: |
  sum without (pod, instance, rcode) (rate(coredns_forward_responses_total{job="kube-dns",rcode="SERVFAIL"}[5m]))
    /
  sum without (pod, instance, rcode) (rate(coredns_forward_responses_total{job="kube-dns"}[5m])) > 0.03
for: 10m
labels:
  severity: critical
{{< /code >}}
 
##### CoreDNSForwardErrorsHigh
https://github.com/povilasv/coredns-mixin/tree/master/runbook.md#alert-name-corednsforwarderrorshigh

{{< code lang="yaml" >}}
alert: CoreDNSForwardErrorsHigh
annotations:
  description: CoreDNS is returning SERVFAIL for {{ $value | humanizePercentage }}
    of forward requests to {{ $labels.to }}.
  runbook_url: https://github.com/povilasv/coredns-mixin/tree/master/runbook.md#alert-name-corednsforwarderrorshigh
  summary: CoreDNS is returning SERVFAIL for forward requests.
expr: |
  sum without (pod, instance, rcode) (rate(coredns_forward_responses_total{job="kube-dns",rcode="SERVFAIL"}[5m]))
    /
  sum without (pod, instance, rcode) (rate(coredns_forward_responses_total{job="kube-dns"}[5m])) > 0.01
for: 10m
labels:
  severity: warning
{{< /code >}}
 
##### CoreDNSForwardHealthcheckFailureCount
https://github.com/povilasv/coredns-mixin/tree/master/runbook.md#alert-name-corednsforwardhealthcheckfailurecount

{{< code lang="yaml" >}}
alert: CoreDNSForwardHealthcheckFailureCount
annotations:
  description: CoreDNS health checks have failed to upstream server {{ $labels.to
    }}.
  runbook_url: https://github.com/povilasv/coredns-mixin/tree/master/runbook.md#alert-name-corednsforwardhealthcheckfailurecount
  summary: CoreDNS health checks have failed to upstream server.
expr: |
  sum without (pod, instance) (rate(coredns_forward_healthcheck_failures_total{job="kube-dns"}[5m])) > 0
for: 10m
labels:
  severity: warning
{{< /code >}}
 
##### CoreDNSForwardHealthcheckBrokenCount
https://github.com/povilasv/coredns-mixin/tree/master/runbook.md#alert-name-corednsforwardhealthcheckbrokencount

{{< code lang="yaml" >}}
alert: CoreDNSForwardHealthcheckBrokenCount
annotations:
  description: CoreDNS health checks have failed for all upstream servers.
  runbook_url: https://github.com/povilasv/coredns-mixin/tree/master/runbook.md#alert-name-corednsforwardhealthcheckbrokencount
  summary: CoreDNS health checks have failed for all upstream servers.
expr: |
  sum without (pod, instance) (rate(coredns_forward_healthcheck_broken_total{job="kube-dns"}[5m])) > 0
for: 10m
labels:
  severity: warning
{{< /code >}}
 
## Dashboards
Following dashboards are generated from mixins and hosted on github:


- [coredns](https://github.com/monitoring-mixins/website/blob/master/assets/coredns/dashboards/coredns.json)
