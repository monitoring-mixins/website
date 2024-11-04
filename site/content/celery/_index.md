---
title: celery
---

## Overview



{{< panel style="danger" >}}
Jsonnet source code is available at [github.com/danihodovic/celery-exporter](https://github.com/danihodovic/celery-exporter/tree/master/celery-mixin)
{{< /panel >}}

## Alerts

{{< panel style="warning" >}}
Complete list of pregenerated alerts is available [here](https://github.com/monitoring-mixins/website/blob/master/assets/celery/alerts.yaml).
{{< /panel >}}

### celery

##### CeleryTaskHighFailRate

{{< code lang="yaml" >}}
alert: CeleryTaskHighFailRate
annotations:
  dashboard_url: https://grafana.com/d/celery-tasks-by-task-32s3/celery-tasks-by-task?var-job={{
    $labels.job }}&var-queue_name={{ $labels.queue_name }}&var-task={{ $labels.name
    }}
  description: More than 5% tasks failed for the task {{ $labels.job }}/{{ $labels.queue_name
    }}/{{ $labels.name }} the past 10m.
  summary: Celery high task fail rate.
expr: |
  sum(
    increase(
      celery_task_failed_total{
        job=~".*celery.*",
        queue_name!~"None",
        name!~"None"
      }[10m]
    )
  )  by (job, namespace, queue_name, name)
  /
  (
    sum(
      increase(
        celery_task_failed_total{
          job=~".*celery.*",
          queue_name!~"None",
          name!~"None"
        }[10m]
      )
    )  by (job, namespace, queue_name, name)
    +
    sum(
      increase(
        celery_task_succeeded_total{
          job=~".*celery.*",
          queue_name!~"None",
          name!~"None"
        }[10m]
      )
    )  by (job, namespace, queue_name, name)
  )
  * 100 > 5
for: 1m
labels:
  severity: warning
{{< /code >}}
 
##### CeleryHighQueueLength

{{< code lang="yaml" >}}
alert: CeleryHighQueueLength
annotations:
  dashboard_url: https://grafana.com/d/celery-tasks-overview-32s3/celery-tasks-overview?&var-job={{
    $labels.job }}&var-queue_name={{ $labels.queue_name }}
  description: More than 100 tasks in the queue {{ $labels.job }}/{{ $labels.queue_name
    }} the past 20m.
  summary: Celery high queue length.
expr: |
  sum(
    celery_queue_length{
      job=~".*celery.*",
      queue_name!~"None"
    }
  )  by (job, namespace, queue_name)
  > 100
for: 20m
labels:
  severity: warning
{{< /code >}}
 
##### CeleryWorkerDown

{{< code lang="yaml" >}}
alert: CeleryWorkerDown
annotations:
  dashboard_url: https://grafana.com/d/celery-tasks-overview-32s3/celery-tasks-overview?&var-job={{
    $labels.job }}
  description: The Celery worker {{ $labels.job }}/{{ $labels.hostname }} is offline.
  summary: A Celery worker is offline.
expr: |
  celery_worker_up{job=~".*celery.*"} == 0
for: 15m
labels:
  severity: warning
{{< /code >}}
 
## Dashboards
Following dashboards are generated from mixins and hosted on github:


- [celery-tasks-by-task](https://github.com/monitoring-mixins/website/blob/master/assets/celery/dashboards/celery-tasks-by-task.json)
- [celery-tasks-overview](https://github.com/monitoring-mixins/website/blob/master/assets/celery/dashboards/celery-tasks-overview.json)
