---
title: django
---

## Overview



{{< panel style="danger" >}}
Jsonnet source code is available at [github.com/adinhodovic/django-mixin](https://github.com/adinhodovic/django-mixin)
{{< /panel >}}

## Alerts

{{< panel style="warning" >}}
Complete list of pregenerated alerts is available [here](https://github.com/monitoring-mixins/website/blob/master/assets/django/alerts.yaml).
{{< /panel >}}

### django

##### DjangoMigrationsUnapplied

{{< code lang="yaml" >}}
alert: DjangoMigrationsUnapplied
annotations:
  dashboard_url: https://grafana.com/d/django-overview-jkwq/django-overview?var-namespace={{
    $labels.namespace }}&var-job={{ $labels.job }}
  description: The job {{ $labels.job }} has unapplied migrations.
  summary: Django has unapplied migrations.
expr: |
  sum(
    django_migrations_unapplied_total{
      job="django"
    }
  ) by (cluster, namespace, job)
  > 0
for: 15m
labels:
  severity: warning
{{< /code >}}
 
##### DjangoDatabaseException

{{< code lang="yaml" >}}
alert: DjangoDatabaseException
annotations:
  dashboard_url: https://grafana.com/d/django-overview-jkwq/django-overview?var-namespace={{
    $labels.namespace }}&var-job={{ $labels.job }}
  description: The job {{ $labels.job }} has hit the database exception {{ $labels.type
    }}.
  summary: Django database exception.
expr: |
  sum (
    increase(
      django_db_errors_total{
        job="django"
      }[10m]
    )
  ) by (cluster, type, namespace, job)
  > 0
labels:
  severity: info
{{< /code >}}
 
##### DjangoHighHttp4xxErrorRate

{{< code lang="yaml" >}}
alert: DjangoHighHttp4xxErrorRate
annotations:
  dashboard_url: https://grafana.com/d/django-requests-by-view-jkwq/django-requests-by-view?var-namespace={{
    $labels.namespace }}&var-job={{ $labels.job }}&var-view={{ $labels.view }}
  description: More than 5% HTTP requests with status 4xx for {{ $labels.job }}/{{
    $labels.view }} the past 5m.
  summary: Django high HTTP 4xx error rate.
expr: |
  sum(
    rate(
      django_http_responses_total_by_status_view_method_total{
        job="django",
        status=~"4.*",
        view!~"<unnamed view>|health_check:health_check_home|prometheus-django-metrics"
      }[5m]
    )
  )  by (cluster, namespace, job, view)
  /
  sum(
    rate(
      django_http_responses_total_by_status_view_method_total{
        job="django",
        view!~"<unnamed view>|health_check:health_check_home|prometheus-django-metrics"
      }[5m]
    )
  )  by (cluster, namespace, job, view)
  * 100 > 5
for: 1m
labels:
  severity: warning
{{< /code >}}
 
##### DjangoHighHttp5xxErrorRate

{{< code lang="yaml" >}}
alert: DjangoHighHttp5xxErrorRate
annotations:
  dashboard_url: https://grafana.com/d/django-requests-by-view-jkwq/django-requests-by-view?var-namespace={{
    $labels.namespace }}&var-job={{ $labels.job }}&var-view={{ $labels.view }}
  description: More than 5% HTTP requests with status 5xx for {{ $labels.job }}/{{
    $labels.view }} the past 5m.
  summary: Django high HTTP 5xx error rate.
expr: |
  sum(
    rate(
      django_http_responses_total_by_status_view_method_total{
        job="django",
        status=~"5.*",
        view!~"<unnamed view>|health_check:health_check_home|prometheus-django-metrics"
      }[5m]
    )
  )  by (cluster, namespace, job, view)
  /
  sum(
    rate(
      django_http_responses_total_by_status_view_method_total{
        job="django",
        view!~"<unnamed view>|health_check:health_check_home|prometheus-django-metrics"
      }[5m]
    )
  )  by (cluster, namespace, job, view)
  * 100 > 5
for: 1m
labels:
  severity: warning
{{< /code >}}
 
## Dashboards
Following dashboards are generated from mixins and hosted on github:


- [django-model-overview](https://github.com/monitoring-mixins/website/blob/master/assets/django/dashboards/django-model-overview.json)
- [django-overview](https://github.com/monitoring-mixins/website/blob/master/assets/django/dashboards/django-overview.json)
- [django-requests-by-view](https://github.com/monitoring-mixins/website/blob/master/assets/django/dashboards/django-requests-by-view.json)
- [django-requests-overview](https://github.com/monitoring-mixins/website/blob/master/assets/django/dashboards/django-requests-overview.json)
