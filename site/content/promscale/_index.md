---
title: promscale
---

## Overview



{{< panel style="danger" >}}
Jsonnet source code is available at [github.com/timescale/promscale](https://github.com/timescale/promscale/tree/master/docs/mixin)
{{< /panel >}}

## Alerts

{{< panel style="warning" >}}
Complete list of pregenerated alerts is available [here](https://github.com/monitoring-mixins/website/blob/master/assets/promscale/alerts.yaml).
{{< /panel >}}

### promscale-general

##### PromscaleDown

{{< code lang="yaml" >}}
alert: PromscaleDown
annotations:
  description: '{{ $labels.instance }} of job {{ $labels.job }} is down.'
  runbook_url: https://github.com/timescale/promscale/blob/master/docs/runbooks/PromscaleDown.md
  summary: Promscale is down.
expr: absent(up{job=~".*promscale.*"})
labels:
  severity: critical
{{< /code >}}
 
### promscale-ingest

##### PromscaleIngestHighErrorRate

{{< code lang="yaml" >}}
alert: PromscaleIngestHighErrorRate
annotations:
  description: Promscale ingestion is having a {{ $value | humanizePercentage }} error
    rate.
  runbook_url: https://github.com/timescale/promscale/blob/master/docs/runbooks/PromscaleIngestHighErrorRate.md
  summary: High error rate in Promscale ingestion.
expr: |
  (
    sum by (job, instance, type) (
      rate(promscale_ingest_requests_total{code=~"5.."}[5m])
    )
  /
    sum by (job, instance, type) (
      rate(promscale_ingest_requests_total[5m])
    )
  ) > 0.05
labels:
  severity: warning
{{< /code >}}
 
##### PromscaleIngestHighErrorRate

{{< code lang="yaml" >}}
alert: PromscaleIngestHighErrorRate
annotations:
  description: Promscale ingestion is having a {{ $value | humanizePercentage }} error
    rate.
  runbook_url: https://github.com/timescale/promscale/blob/master/docs/runbooks/PromscaleIngestHighErrorRate.md
  summary: High error rate in Promscale ingestion.
expr: |
  (
    sum by (job, instance, type) (
      rate(promscale_ingest_requests_total{code=~"5.."}[5m])
    )
  /
    sum by (job, instance, type) (
      rate(promscale_ingest_requests_total[5m])
    )
  ) > 0.1
labels:
  severity: critical
{{< /code >}}
 
##### PromscaleIngestHighLatency

{{< code lang="yaml" >}}
alert: PromscaleIngestHighLatency
annotations:
  description: Slowest 10% of ingestion batch took more than {{ $value }} seconds
    to ingest.
  runbook_url: https://github.com/timescale/promscale/blob/master/docs/runbooks/PromscaleIngestHighLatency.md
  summary: Slow Promscale ingestion.
expr: |
  (
    histogram_quantile(
      0.90,
      sum by (job, instance, type, le) (
        rate(promscale_ingest_duration_seconds_bucket[5m])
      )
    ) > 10
  and
    sum by (job, instance, type) (
        rate(promscale_ingest_duration_seconds_bucket[5m])
    )
  ) > 0
for: 5m
labels:
  severity: warning
{{< /code >}}
 
##### PromscaleIngestHighLatency

{{< code lang="yaml" >}}
alert: PromscaleIngestHighLatency
annotations:
  description: Slowest 10% of ingestion batch took more than {{ $value }} seconds
    to ingest.
  runbook_url: https://github.com/timescale/promscale/blob/master/docs/runbooks/PromscaleIngestHighLatency.md
  summary: Slow Promscale ingestion.
expr: |
  (
    histogram_quantile(
      0.90,
      sum by (job, instance, type, le) (
        rate(promscale_ingest_duration_seconds_bucket[5m])
      )
    ) > 30
  and
    sum by (job, instance, type) (
        rate(promscale_ingest_duration_seconds_bucket[5m])
    )
  ) > 0
for: 5m
labels:
  severity: critical
{{< /code >}}
 
### promscale-query

##### PromscaleQueryHighErrorRate

{{< code lang="yaml" >}}
alert: PromscaleQueryHighErrorRate
annotations:
  description: Evaluating queries via Promscale has {{ $value | humanizePercentage
    }} error rate.
  runbook_url: https://github.com/timescale/promscale/blob/master/docs/runbooks/PromscaleQueryHighErrorRate.md
  summary: High error rate in querying Promscale.
expr: |
  (
    sum by (job, instance, type) (
      rate(promscale_query_requests_total{code=~"5.."}[5m])
    )
  /
    sum by (job, instance, type) (
      rate(promscale_query_requests_total[5m])
    )
  ) > 0.05
labels:
  severity: warning
{{< /code >}}
 
##### PromscaleQueryHighErrorRate

{{< code lang="yaml" >}}
alert: PromscaleQueryHighErrorRate
annotations:
  description: Evaluating queries via Promscale had {{ $value | humanizePercentage
    }} error rate.
  runbook_url: https://github.com/timescale/promscale/blob/master/docs/runbooks/PromscaleQueryHighErrorRate.md
  summary: High error rate in querying Promscale.
expr: |
  (
    sum by (job, instance, type) (
      rate(promscale_query_requests_total{code=~"5.."}[5m])
    )
  /
    sum by (job, instance, type) (
      rate(promscale_query_requests_total[5m])
    )
  ) > 0.1
labels:
  severity: critical
{{< /code >}}
 
##### PromscaleQueryHighLatency

{{< code lang="yaml" >}}
alert: PromscaleQueryHighLatency
annotations:
  description: Slowest 10% of the queries took more than {{ $value }} seconds to evaluate.
  runbook_url: https://github.com/timescale/promscale/blob/master/docs/runbooks/PromscaleQueryHighLatency.md
  summary: Slow Promscale querying.
expr: |
  (
    histogram_quantile(
      0.90,
      sum by (job, instance, type, le) (
        rate(promscale_query_duration_seconds_bucket[5m])
      )
    ) > 5
  and
    sum by (job, instance, type) (
      rate(promscale_query_duration_seconds_bucket[5m])
    ) > 0
  )
for: 5m
labels:
  severity: warning
{{< /code >}}
 
##### PromscaleQueryHighLatency

{{< code lang="yaml" >}}
alert: PromscaleQueryHighLatency
annotations:
  description: Slowest 10% of the queries took {{ $value }} seconds to evaluate.
  runbook_url: https://github.com/timescale/promscale/blob/master/docs/runbooks/PromscaleQueryHighLatency.md
  summary: Slow Promscale querying.
expr: |
  (
    histogram_quantile(
      0.90,
      sum by (job, instance, type, le) (
        rate(promscale_query_duration_seconds_bucket[5m])
      )
    ) > 10
  and
    sum by (job, instance, type) (
      rate(promscale_query_duration_seconds_bucket[5m])
    ) > 0
  )
for: 5m
labels:
  severity: critical
{{< /code >}}
 
### promscale-cache

##### PromscaleCacheHighNumberOfEvictions

{{< code lang="yaml" >}}
alert: PromscaleCacheHighNumberOfEvictions
annotations:
  description: Promscale {{ $labels.name }} is evicting at {{ $value }} entries a
    second.
  runbook_url: https://github.com/timescale/promscale/blob/master/docs/runbooks/PromscaleCacheHighNumberOfEvictions.md
  summary: High cache eviction in Promscale.
expr: |
  (
    sum by (job, instance, name, type) (
      rate(promscale_cache_evictions_total[5m])
    )
  /
    sum by (job, instance, name, type) (
      promscale_cache_capacity_elements
    )
  ) > 0.2
labels:
  severity: warning
{{< /code >}}
 
##### PromscaleCacheTooSmall

{{< code lang="yaml" >}}
alert: PromscaleCacheTooSmall
annotations:
  description: Promscale {{ $labels.name }} has a hit ratio of {{ $value | humanizePercentage
    }}.
  runbook_url: https://github.com/timescale/promscale/blob/master/docs/runbooks/PromscaleCacheTooSmall.md
  summary: High cache eviction in Promscale.
expr: |
  (
    sum by (job, instance, type, name) (
      rate(promscale_cache_query_hits_total[5m])
    )
  /
    sum by (job, instance, type, name) (
      rate(promscale_cache_queries_total[5m])
    )
  ) < 0.9
labels:
  severity: warning
{{< /code >}}
 
### promscale-database-connection

##### PromscaleDBHighErrorRate

{{< code lang="yaml" >}}
alert: PromscaleDBHighErrorRate
annotations:
  description: Promscale connection with the database has an error of {{ $value |
    humanizePercentage }}.
  runbook_url: https://github.com/timescale/promscale/blob/master/docs/runbooks/PromscaleDBHighErrorRate.md
  summary: Promscale experiences a high error rate when connecting to the database.
expr: |
  (
    sum by (job) (
      # Error counter exists for query, query_row & exec, and not for send_batch.
      rate(promscale_database_request_errors_total{method=~"query.*|exec"}[5m])
    )
  /
    sum by (job) (
      rate(promscale_database_requests_total{method=~"query.*|exec"}[5m])
    )
  ) > 0.05
labels:
  severity: warning
{{< /code >}}
 
##### PromscaleStorageHighLatency

{{< code lang="yaml" >}}
alert: PromscaleStorageHighLatency
annotations:
  description: Slowest 10% of database requests are taking more than {{ $value }}
    seconds to respond.
  runbook_url: https://github.com/timescale/promscale/blob/master/docs/runbooks/PromscaleStorageHighLatency.md
  summary: Slow database response.
expr: |
  (
    histogram_quantile(0.9,
      sum by (le, job, type) (
        rate(promscale_database_requests_duration_seconds_bucket[5m])
      )
    ) > 5
  and
    sum by (job, type) (
      rate(promscale_database_requests_duration_seconds_count[5m])
    ) > 0
  )
labels:
  severity: warning
{{< /code >}}
 
### promscale-database

##### PromscaleStorageUnhealthy

{{< code lang="yaml" >}}
alert: PromscaleStorageUnhealthy
annotations:
  description: Promscale connection with the database has an error of {{ $value |
    humanizePercentage }}.
  runbook_url: https://github.com/timescale/promscale/blob/master/docs/runbooks/PromscaleStorageUnhealthy.md
  summary: Promscale database is unhealthy.
expr: |
  (
    sum by (job) (
      rate(promscale_sql_database_health_check_errors_total[5m])
    )
  /
    sum by (job) (
      rate(promscale_sql_database_health_check_total[5m])
    )
  ) > 0.05
labels:
  severity: warning
{{< /code >}}
 
##### PromscaleMaintenanceJobRunningTooLong

{{< code lang="yaml" >}}
alert: PromscaleMaintenanceJobRunningTooLong
annotations:
  description: Promscale Database is taking {{ $value }} seconds to respond to Promscale's
    requests.
  runbook_url: https://github.com/timescale/promscale/blob/master/docs/runbooks/PromscaleMaintenanceJobRunningTooLong.md
  summary: Promscale maintenance jobs taking too long to complete.
expr: |
  (
    (
      (
        time()
      -
        promscale_sql_database_worker_maintenance_job_start_timestamp_seconds
      )
        >
          30 * 60 * 2 # 30 mins (we launch maintenance jobs scheduled at 30 mins) * 60 (to seconds) * 2 (wait max for 2 complete scans before firing alert).
    )
  and
    promscale_sql_database_worker_maintenance_job_start_timestamp_seconds > 0
  )
labels:
  severity: warning
{{< /code >}}
 
##### PromscaleMaintenanceJobFailures

{{< code lang="yaml" >}}
alert: PromscaleMaintenanceJobFailures
annotations:
  description: Maintenance job for Promscale instance {{ $labels.instance }} failed
    to successfully execute.
  runbook_url: https://github.com/timescale/promscale/blob/master/docs/runbooks/PromscaleMaintenanceJobFailures.md
  summary: Promscale maintenance job failed.
expr: promscale_sql_database_worker_maintenance_job_failed == 1
labels:
  severity: warning
{{< /code >}}
 
##### PromscaleCompressionLow

{{< code lang="yaml" >}}
alert: PromscaleCompressionLow
annotations:
  description: High uncompressed data in Promscale, on average, {{ $value }} uncompressed
    chunks per metric.
  runbook_url: https://github.com/timescale/promscale/blob/master/docs/runbooks/PromscaleCompressionLow.md
  summary: High uncompressed data.
expr: |
  (
    (
      (promscale_sql_database_chunks_count - promscale_sql_database_chunks_compressed_count) # Number of uncompressed chunks.
    /
      promscale_sql_database_metric_count
    ) > 4 # If total number of average uncompressed chunk per metric is more than 4 chunks at maximum, we should alert.
  and
    promscale_sql_database_compression_status == 1
  )
labels:
  severity: warning
{{< /code >}}
 
## Dashboards
Following dashboards are generated from mixins and hosted on github:


- [apm-dependencies](https://github.com/monitoring-mixins/website/blob/master/assets/promscale/dashboards/apm-dependencies.json)
- [apm-home](https://github.com/monitoring-mixins/website/blob/master/assets/promscale/dashboards/apm-home.json)
- [apm-service-dependencies-downstream](https://github.com/monitoring-mixins/website/blob/master/assets/promscale/dashboards/apm-service-dependencies-downstream.json)
- [apm-service-dependencies-upstream](https://github.com/monitoring-mixins/website/blob/master/assets/promscale/dashboards/apm-service-dependencies-upstream.json)
- [apm-service-overview](https://github.com/monitoring-mixins/website/blob/master/assets/promscale/dashboards/apm-service-overview.json)
- [promscale](https://github.com/monitoring-mixins/website/blob/master/assets/promscale/dashboards/promscale.json)
