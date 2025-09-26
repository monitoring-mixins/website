---
title: gitlab
---

## Overview



{{< panel style="danger" >}}
Jsonnet source code is available at [github.com/grafana/jsonnet-libs](https://github.com/grafana/jsonnet-libs/tree/master/gitlab-mixin)
{{< /panel >}}

## Alerts

{{< panel style="warning" >}}
Complete list of pregenerated alerts is available [here](https://github.com/monitoring-mixins/website/blob/master/assets/gitlab/alerts.yaml).
{{< /panel >}}

### GitLabAlerts

##### GitLabHighJobRegistrationFailures

{{< code lang="yaml" >}}
alert: GitLabHighJobRegistrationFailures
annotations:
  description: '{{ printf "%.2f" $value }}% of job registrations have failed on {{$labels.instance}},
    which is above threshold of 10%.'
  summary: Large percentage of failed attempts to register a job.
expr: "100 * rate(job_register_attempts_failed_total{job=\"integrations/gitlab\"}[5m])
  / rate(job_register_attempts_total{job=\"integrations/gitlab\"}[5m]) 
> 10
"
for: 5m
labels:
  severity: warning
{{< /code >}}
 
##### GitLabHighRunnerAuthFailure

{{< code lang="yaml" >}}
alert: GitLabHighRunnerAuthFailure
annotations:
  description: '{{ printf "%.2f" $value }}% of GitLab runner authentication attempts
    are failing on {{$labels.instance}}, which is above the threshold of 10%.'
  summary: Large percentage of runner authentication failures.
expr: "100 * sum by (instance) (rate(gitlab_ci_runner_authentication_failure_total{job=\"integrations/gitlab\"}[5m]))
  \ / 
(sum by (instance) (rate(gitlab_ci_runner_authentication_success_total{job=\"integrations/gitlab\"}[5m]))
  \ + sum by (instance) (rate(gitlab_ci_runner_authentication_failure_total{job=\"integrations/gitlab\"}[5m])))
>
  10
"
for: 5m
labels:
  severity: warning
{{< /code >}}
 
##### GitLabHigh5xxResponses

{{< code lang="yaml" >}}
alert: GitLabHigh5xxResponses
annotations:
  description: '{{ printf "%.2f" $value }}% of all requests returned 5XX HTTP responses,
    which is above the threshold 10%, indicating a system issue on {{$labels.instance}}.'
  summary: Large rate of HTTP 5XX errors.
expr: "100 * sum by (instance, status) (rate(http_requests_total{job=\"integrations/gitlab\",status=~\"5[0-9][0-9]\"}[5m]))
  / sum by (instance) (rate(http_requests_total{job=\"integrations/gitlab\"}[5m]))
  
> 10
"
for: 5m
labels:
  severity: critical
{{< /code >}}
 
##### GitLabHigh4xxResponses

{{< code lang="yaml" >}}
alert: GitLabHigh4xxResponses
annotations:
  description: '{{ printf "%.2f" $value }}% of all requests returned 4XX HTTP responses,
    which is above the threshold 10%, indicating many failed requests on {{$labels.instance}}.'
  summary: Large rate of HTTP 4XX errors.
expr: |
  100 * sum by (instance, status) (rate(http_requests_total{job="integrations/gitlab",status=~"4[0-9][0-9]"}[5m])) / sum by (instance) (rate(http_requests_total{job="integrations/gitlab"}[5m]))
  > 10
for: 5m
labels:
  severity: warning
{{< /code >}}
 
## Dashboards
Following dashboards are generated from mixins and hosted on github:


- [gitlab-logs](https://github.com/monitoring-mixins/website/blob/master/assets/gitlab/dashboards/gitlab-logs.json)
- [gitlab-overview](https://github.com/monitoring-mixins/website/blob/master/assets/gitlab/dashboards/gitlab-overview.json)
