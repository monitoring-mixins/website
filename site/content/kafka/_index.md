---
title: kafka
---

## Overview



{{< panel style="danger" >}}
Jsonnet source code is available at [github.com/grafana/jsonnet-libs](https://github.com/grafana/jsonnet-libs/tree/master/kafka-mixin)
{{< /panel >}}

## Alerts

{{< panel style="warning" >}}
Complete list of pregenerated alerts is available [here](https://github.com/monitoring-mixins/website/blob/master/assets/kafka/alerts.yaml).
{{< /panel >}}

### Kafka_Alerts

##### KafkaOfflinePartitonCount

{{< code lang="yaml" >}}
alert: KafkaOfflinePartitonCount
annotations:
  description: Kafka cluster {{ $labels.kafka_cluster }} has {{ $value }} offline
    partitions. After successful leader election, if the leader for partition dies,
    then the partition moves to the OfflinePartition state. Offline partitions are
    not available for reading and writing. Restart the brokers, if needed, and check
    the logs for errors.
  summary: Kafka has offline partitons.
expr: sum without(instance) (kafka_controller_kafkacontroller_offlinepartitionscount{job="integrations/kafka"})
  > 0
for: 5m
labels:
  severity: critical
{{< /code >}}
 
##### KafkaUnderReplicatedPartitionCount

{{< code lang="yaml" >}}
alert: KafkaUnderReplicatedPartitionCount
annotations:
  description: Kafka instance {{ $labels.instance }} in cluster {{ $labels.kafka_cluster
    }} has {{ $value }} under replicated partitons
  summary: Kafka has under replicated partitons.
expr: |
  sum without() (kafka_server_replicamanager_underreplicatedpartitions{job="integrations/kafka"}) > 0
for: 5m
labels:
  severity: critical
{{< /code >}}
 
##### KafkaActiveController

{{< code lang="yaml" >}}
alert: KafkaActiveController
annotations:
  description: Kafka cluster {{ $labels.kafka_cluster }} has {{ $value }} broker(s)
    reporting as the active controller in the last 5 minute interval. During steady
    state there should be only one active controller per cluster.
  summary: Kafka has no active controller.
expr: sum without(instance) (kafka_controller_kafkacontroller_activecontrollercount{job="integrations/kafka"})
  != 1
for: 5m
labels:
  severity: critical
{{< /code >}}
 
##### KafkaUncleanLeaderElection

{{< code lang="yaml" >}}
alert: KafkaUncleanLeaderElection
annotations:
  description: Kafka cluster {{ $labels.kafka_cluster }} has {{ $value }} unclean
    partition leader elections reported in the last 5 minute interval. When unclean
    leader election is held among out-of-sync replicas, there is a possibility of
    data loss if any messages were not synced prior to the loss of the former leader.
    So if the number of unclean elections is greater than 0, investigate broker logs
    to determine why leaders were re-elected, and look for WARN or ERROR messages.
    Consider setting the broker configuration parameter unclean.leader.election.enable
    to false so that a replica outside of the set of in-sync replicas is never elected
    leader.
  summary: Kafka has unclean leader elections.
expr: max without(instance) (rate(kafka_controller_controllerstats_uncleanleaderelectionspersec{job="integrations/kafka"}[5m]))
  != 0
for: 5m
labels:
  severity: critical
{{< /code >}}
 
##### KafkaISRExpandRate

{{< code lang="yaml" >}}
alert: KafkaISRExpandRate
annotations:
  description: Kafka instance {{ $labels.instance }} in cluster {{ $labels.kafka_cluster
    }} ISR is expanding by {{ $value }} per second. If a broker goes down, ISR for
    some of the partitions shrink. When that broker is up again, ISRs are expanded
    once the replicas are fully caught up. Other than that, the expected value for
    ISR expansion rate is 0. If ISR is expanding and shrinking frequently, adjust
    Allowed replica lag.
  summary: Kafka ISR Expansion Rate is expanding.
expr: |
  sum without() (rate(kafka_server_replicamanager_isrexpandspersec{job="integrations/kafka"}[5m])) != 0
for: 5m
labels:
  severity: warning
{{< /code >}}
 
##### KafkaISRShrinkRate

{{< code lang="yaml" >}}
alert: KafkaISRShrinkRate
annotations:
  description: Kafka instance {{ $labels.instance }} in cluster {{ $labels.kafka_cluster
    }} ISR is shrinking by {{ $value }} per second. If a broker goes down, ISR for
    some of the partitions shrink. When that broker is up again, ISRs are expanded
    once the replicas are fully caught up. Other than that, the expected value for
    ISR shrink rate is 0. If ISR is expanding and shrinking frequently, adjust Allowed
    replica lag.
  summary: Kafka ISR Expansion Rate is shrinking.
expr: |
  sum without() (rate(kafka_server_replicamanager_isrshrinkspersec{job="integrations/kafka"}[5m])) != 0
for: 5m
labels:
  severity: warning
{{< /code >}}
 
##### KafkaBrokerCount

{{< code lang="yaml" >}}
alert: KafkaBrokerCount
annotations:
  description: Kafka cluster {{ $labels.kafka_cluster }} broker count is 0.
  summary: Kafka has no Brokers online.
expr: count without(instance) (kafka_server_kafkaserver_brokerstate{job="integrations/kafka"})
  == 0
for: 5m
labels:
  severity: critical
{{< /code >}}
 
##### KafkaZookeeperSyncConnect

{{< code lang="yaml" >}}
alert: KafkaZookeeperSyncConnect
annotations:
  description: Kafka instance {{ $labels.instance }} in cluster {{ $labels.kafka_cluster
    }} Zookeeper Sync Disconected.
  summary: Kafka Zookeeper Sync Disconected.
expr: |
  avg without() (kafka_server_sessionexpirelistener_zookeepersyncconnectspersec{job="integrations/kafka"}) < 0
for: 5m
labels:
  severity: warning
{{< /code >}}
 
## Dashboards
Following dashboards are generated from mixins and hosted on github:


- [connect-overview](https://github.com/monitoring-mixins/website/blob/master/assets/kafka/dashboards/connect-overview.json)
- [kafka-ksqldb-overview](https://github.com/monitoring-mixins/website/blob/master/assets/kafka/dashboards/kafka-ksqldb-overview.json)
- [kafka-lag-overview](https://github.com/monitoring-mixins/website/blob/master/assets/kafka/dashboards/kafka-lag-overview.json)
- [kafka-overview](https://github.com/monitoring-mixins/website/blob/master/assets/kafka/dashboards/kafka-overview.json)
- [kafka-topics](https://github.com/monitoring-mixins/website/blob/master/assets/kafka/dashboards/kafka-topics.json)
- [schema-registry-overview](https://github.com/monitoring-mixins/website/blob/master/assets/kafka/dashboards/schema-registry-overview.json)
- [zookeeper-overview](https://github.com/monitoring-mixins/website/blob/master/assets/kafka/dashboards/zookeeper-overview.json)
