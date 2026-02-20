---
title: apache-airflow
---

## Overview



{{< panel style="danger" >}}
Jsonnet source code is available at [github.com/grafana/jsonnet-libs](https://github.com/grafana/jsonnet-libs/tree/master/apache-airflow-mixin)
{{< /panel >}}

## Alerts

{{< panel style="warning" >}}
Complete list of pregenerated alerts is available [here](https://github.com/monitoring-mixins/website/blob/master/assets/apache-airflow/alerts.yaml).
{{< /panel >}}

### apache-airflow-alerts

##### ApacheAirflowStarvingPoolTasks

{{< code lang="yaml" >}}
alert: ApacheAirflowStarvingPoolTasks
annotations:
  description: |
    The number of starved tasks is {{ printf "%.0f" $value }} over the last 5m on {{ $labels.instance }} - {{ $labels.pool_name }} which is above the threshold of 0.
  summary: There are starved tasks detected in the Apache Airflow pool.
expr: |
  airflow_pool_starving_tasks{} > 0
for: 5m
labels:
  severity: critical
{{< /code >}}
 
##### ApacheAirflowDAGScheduleDelayWarning

{{< code lang="yaml" >}}
alert: ApacheAirflowDAGScheduleDelayWarning
annotations:
  description: |
    The average delay in DAG schedule to run time is {{ printf "%.0f" $value }} over the last 1m on {{ $labels.instance }} - {{ $labels.dag_id }} which is above the threshold of 10.
  summary: The delay in DAG schedule time to DAG run time has reached the warning
    threshold.
expr: |
  increase(airflow_dagrun_schedule_delay_sum{}[5m]) / clamp_min(increase(airflow_dagrun_schedule_delay_count{}[5m]),1) > 10
for: 1m
labels:
  severity: warning
{{< /code >}}
 
##### ApacheAirflowDAGScheduleDelayCritical

{{< code lang="yaml" >}}
alert: ApacheAirflowDAGScheduleDelayCritical
annotations:
  description: |
    The average delay in DAG schedule to run time is {{ printf "%.0f" $value }} over the last 1m for {{ $labels.instance }} - {{ $labels.dag_id }} which is above the threshold of 60.
  summary: The delay in DAG schedule time to DAG run time has reached the critical
    threshold.
expr: |
  increase(airflow_dagrun_schedule_delay_sum{}[5m]) / clamp_min(increase(airflow_dagrun_schedule_delay_count{}[5m]),1) > 60
for: 1m
labels:
  severity: critical
{{< /code >}}
 
##### ApacheAirflowDAGFailures

{{< code lang="yaml" >}}
alert: ApacheAirflowDAGFailures
annotations:
  description: |
    The number of DAG failures seen is {{ printf "%.0f" $value }} over the last 1m for {{ $labels.instance }} - {{ $labels.dag_id }} which is above the threshold of 0.
  summary: There have been DAG failures detected.
expr: |
  increase(airflow_dagrun_duration_failed_count{}[5m]) > 0
for: 1m
labels:
  severity: critical
{{< /code >}}
 
## Dashboards
Following dashboards are generated from mixins and hosted on github:


- [apache-airflow-logs](https://github.com/monitoring-mixins/website/blob/master/assets/apache-airflow/dashboards/apache-airflow-logs.json)
- [apache-airflow-overview](https://github.com/monitoring-mixins/website/blob/master/assets/apache-airflow/dashboards/apache-airflow-overview.json)
