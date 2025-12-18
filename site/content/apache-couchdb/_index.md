---
title: apache-couchdb
---

## Overview



{{< panel style="danger" >}}
Jsonnet source code is available at [github.com/grafana/jsonnet-libs](https://github.com/grafana/jsonnet-libs/tree/master/apache-couchdb-mixin)
{{< /panel >}}

## Alerts

{{< panel style="warning" >}}
Complete list of pregenerated alerts is available [here](https://github.com/monitoring-mixins/website/blob/master/assets/apache-couchdb/alerts.yaml).
{{< /panel >}}

### ApacheCouchDBAlerts

##### CouchDBUnhealthyCluster

{{< code lang="yaml" >}}
alert: CouchDBUnhealthyCluster
annotations:
  description: '{{$labels.couchdb_cluster}} has reported a value of {{ printf "%.0f"
    $value }} for its stability over the last 5 minutes, which is below the threshold
    of 1.'
  summary: At least one of the nodes in a cluster is reporting the cluster as being
    unstable.
expr: |
  min by(job, couchdb_cluster) (couchdb_couch_replicator_cluster_is_stable{}) < 1
for: 5m
labels:
  severity: critical
{{< /code >}}
 
##### CouchDBHigh4xxResponseCodes

{{< code lang="yaml" >}}
alert: CouchDBHigh4xxResponseCodes
annotations:
  description: '{{ printf "%.0f" $value }} 4xx responses have been detected over the
    last 5 minutes on {{$labels.instance}}, which is above the threshold of 5.'
  summary: There are a high number of 4xx responses for incoming requests to a node.
expr: |
  sum by(job, instance) (increase(couchdb_httpd_status_codes{code=~"4.."}[5m])) > 5
for: 5m
labels:
  severity: warning
{{< /code >}}
 
##### CouchDBHigh5xxResponseCodes

{{< code lang="yaml" >}}
alert: CouchDBHigh5xxResponseCodes
annotations:
  description: '{{ printf "%.0f" $value }} 5xx responses have been detected over the
    last 5 minutes on {{$labels.instance}}, which is above the threshold of 0.'
  summary: There are a high number of 5xx responses for incoming requests to a node.
expr: |
  sum by(job, instance) (increase(couchdb_httpd_status_codes{code=~"5.."}[5m])) > 0
for: 5m
labels:
  severity: critical
{{< /code >}}
 
##### CouchDBModerateRequestLatency

{{< code lang="yaml" >}}
alert: CouchDBModerateRequestLatency
annotations:
  description: 'An average of {{ printf "%.0f" $value }}ms of request latency has
    occurred over the last 5 minutes on {{$labels.instance}}, which is above the threshold
    of 500ms. '
  summary: There is a moderate level of request latency for a node.
expr: |
  sum by(job, instance) (rate(couchdb_request_time_seconds_sum{}[5m]) / rate(couchdb_request_time_seconds_count{}[5m])) * 1000 > 500
for: 5m
labels:
  severity: warning
{{< /code >}}
 
##### CouchDBHighRequestLatency

{{< code lang="yaml" >}}
alert: CouchDBHighRequestLatency
annotations:
  description: 'An average of {{ printf "%.0f" $value }}ms of request latency has
    occurred over the last 5 minutes on {{$labels.instance}}, which is above the threshold
    of 1000ms. '
  summary: There is a high level of request latency for a node.
expr: |
  sum by(job, instance) (rate(couchdb_request_time_seconds_sum{}[5m]) / rate(couchdb_request_time_seconds_count{}[5m])) * 1000 > 1000
for: 5m
labels:
  severity: critical
{{< /code >}}
 
##### CouchDBManyReplicatorJobsPending

{{< code lang="yaml" >}}
alert: CouchDBManyReplicatorJobsPending
annotations:
  description: '{{ printf "%.0f" $value }} replicator jobs are pending on {{$labels.instance}},
    which is above the threshold of 10. '
  summary: There is a high number of replicator jobs pending for a node.
expr: |
  sum by(job, instance) (couchdb_couch_replicator_jobs_pending{}) > 10
for: 5m
labels:
  severity: warning
{{< /code >}}
 
##### CouchDBReplicatorJobsCrashing

{{< code lang="yaml" >}}
alert: CouchDBReplicatorJobsCrashing
annotations:
  description: '{{ printf "%.0f" $value }} replicator jobs have crashed over the last
    5 minutes on {{$labels.instance}}, which is above the threshold of 0. '
  summary: There are replicator jobs crashing for a node.
expr: |
  sum by(job, instance) (increase(couchdb_couch_replicator_jobs_crashes_total{}[5m])) > 0
for: 5m
labels:
  severity: critical
{{< /code >}}
 
##### CouchDBReplicatorChangesQueuesDying

{{< code lang="yaml" >}}
alert: CouchDBReplicatorChangesQueuesDying
annotations:
  description: '{{ printf "%.0f" $value }} replicator changes queue processes have
    died over the last 5 minutes on {{$labels.instance}}, which is above the threshold
    of 0. '
  summary: There are replicator changes queue process deaths for a node.
expr: |
  sum by(job, instance) (increase(couchdb_couch_replicator_changes_queue_deaths_total{}[5m])) > 0
for: 5m
labels:
  severity: warning
{{< /code >}}
 
##### CouchDBReplicatorOwnersCrashing

{{< code lang="yaml" >}}
alert: CouchDBReplicatorOwnersCrashing
annotations:
  description: '{{ printf "%.0f" $value }} replicator connection owner processes have
    crashed over the last 5 minutes on {{$labels.instance}}, which is above the threshold
    of 0. '
  summary: There are replicator connection owner process crashes for a node.
expr: |
  sum by(job, instance) (increase(couchdb_couch_replicator_connection_owner_crashes_total{}[5m])) > 0
for: 5m
labels:
  severity: warning
{{< /code >}}
 
##### CouchDBReplicatorWorkersCrashing

{{< code lang="yaml" >}}
alert: CouchDBReplicatorWorkersCrashing
annotations:
  description: '{{ printf "%.0f" $value }} replicator connection worker processes
    have crashed over the last 5 minutes on {{$labels.instance}}, which is above the
    threshold of 0. '
  summary: There are replicator connection worker process crashes for a node.
expr: |
  sum by(job, instance) (increase(couchdb_couch_replicator_connection_worker_crashes_total{}[5m])) > 0
for: 5m
labels:
  severity: warning
{{< /code >}}
 
## Dashboards
Following dashboards are generated from mixins and hosted on github:


- [couchdb-logs](https://github.com/monitoring-mixins/website/blob/master/assets/apache-couchdb/dashboards/couchdb-logs.json)
- [couchdb-nodes](https://github.com/monitoring-mixins/website/blob/master/assets/apache-couchdb/dashboards/couchdb-nodes.json)
- [couchdb-overview](https://github.com/monitoring-mixins/website/blob/master/assets/apache-couchdb/dashboards/couchdb-overview.json)
