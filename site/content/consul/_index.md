---
title: consul
---

## Overview

Grafana dashboards and Prometheus alerts for operating Consul, in the form of a monitoring mixin.

{{< panel style="danger" >}}
Jsonnet source code is available at [github.com/grafana/jsonnet-libs](https://github.com/grafana/jsonnet-libs/tree/master/consul-mixin)
{{< /panel >}}

## Alerts

{{< panel style="warning" >}}
Complete list of pregenerated alerts is available [here](https://github.com/monitoring-mixins/website/blob/master/assets/consul/alerts.yaml).
{{< /panel >}}

### consul

##### ConsulUp

{{< code lang="yaml" >}}
alert: ConsulUp
annotations:
  description: Consul '{{ $labels.job }}' is not up.
  summary: Consul is not up.
expr: |
  consul_up != 1
for: 1m
labels:
  severity: critical
{{< /code >}}
 
##### ConsulMaster

{{< code lang="yaml" >}}
alert: ConsulMaster
annotations:
  description: Consul '{{ $labels.job }}' has no master.
  summary: Consul has no master.
expr: |
  consul_raft_leader != 1
for: 1m
labels:
  severity: critical
{{< /code >}}
 
##### ConsulPeers

{{< code lang="yaml" >}}
alert: ConsulPeers
annotations:
  description: Consul '{{ $labels.job }}' does not have 3 peers.
  summary: Consul does not have peers.
expr: |
  consul_raft_peers != 3
for: 10m
labels:
  severity: critical
{{< /code >}}
 
