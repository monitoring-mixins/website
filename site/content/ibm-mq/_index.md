---
title: ibm-mq
---

## Overview



{{< panel style="danger" >}}
Jsonnet source code is available at [github.com/grafana/jsonnet-libs](https://github.com/grafana/jsonnet-libs/tree/master/ibm-mq-mixin)
{{< /panel >}}

## Alerts

{{< panel style="warning" >}}
Complete list of pregenerated alerts is available [here](https://github.com/monitoring-mixins/website/blob/master/assets/ibm-mq/alerts.yaml).
{{< /panel >}}

### ibm-mq-alerts

##### IBMMQExpiredMessages

{{< code lang="yaml" >}}
alert: IBMMQExpiredMessages
annotations:
  description: The number of expired messages in the {{$labels.qmgr}} is {{ printf
    "%.0f" $value }} which is above the threshold of 2.
  summary: There are expired messages, which imply that application resilience is
    failing.
expr: |
  sum without (description,hostname,instance,job,platform) (ibmmq_qmgr_expired_message_count{}) > 2
for: 5m
labels:
  severity: critical
{{< /code >}}
 
##### IBMMQStaleMessages

{{< code lang="yaml" >}}
alert: IBMMQStaleMessages
annotations:
  description: A stale message with an age of {{ printf "%.0f" $value }}s has been
    sitting in the {{$labels.queue}} which is above the threshold of 300s.
  summary: Stale messages have been detected.
expr: |
  sum without (description,instance,job,platform) (ibmmq_queue_oldest_message_age{}) >= 300
for: 5m
labels:
  severity: warning
{{< /code >}}
 
##### IBMMQLowDiskSpace

{{< code lang="yaml" >}}
alert: IBMMQLowDiskSpace
annotations:
  description: The amount of disk space available for {{$labels.qmgr}} is at {{ printf
    "%.0f" $value }}% which is below the threshold of 5%.
  summary: There is limited disk available for a queue manager.
expr: |
  sum without (description,hostname,instance,job,platform) (ibmmq_qmgr_queue_manager_file_system_free_space_percentage{}) < 5
for: 5m
labels:
  severity: critical
{{< /code >}}
 
##### IBMMQHighQueueManagerCpuUsage

{{< code lang="yaml" >}}
alert: IBMMQHighQueueManagerCpuUsage
annotations:
  description: The amount of CPU usage for the queue manager {{$labels.qmgr}} is at
    {{ printf "%.0f" $value }}% which is above the threshold of 85%.
  summary: There is a high CPU usage estimate for a queue manager.
expr: |
  sum without (description,hostname,instance,job,platform) (ibmmq_qmgr_user_cpu_time_estimate_for_queue_manager_percentage{}) > 85
for: 5m
labels:
  severity: critical
{{< /code >}}
 
## Dashboards
Following dashboards are generated from mixins and hosted on github:


- [ibm-mq-cluster-overview](https://github.com/monitoring-mixins/website/blob/master/assets/ibm-mq/dashboards/ibm-mq-cluster-overview.json)
- [ibm-mq-logs](https://github.com/monitoring-mixins/website/blob/master/assets/ibm-mq/dashboards/ibm-mq-logs.json)
- [ibm-mq-queue-manager-overview](https://github.com/monitoring-mixins/website/blob/master/assets/ibm-mq/dashboards/ibm-mq-queue-manager-overview.json)
- [ibm-mq-queue-overview](https://github.com/monitoring-mixins/website/blob/master/assets/ibm-mq/dashboards/ibm-mq-queue-overview.json)
- [ibm-mq-topics-overview](https://github.com/monitoring-mixins/website/blob/master/assets/ibm-mq/dashboards/ibm-mq-topics-overview.json)
