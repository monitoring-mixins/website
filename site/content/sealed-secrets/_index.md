---
title: sealed-secrets
---

## Overview



{{< panel style="danger" >}}
Jsonnet source code is available at [github.com/bitnami-labs/sealed-secrets](https://github.com/bitnami-labs/sealed-secrets/tree/master/contrib/prometheus-mixin)
{{< /panel >}}

## Alerts

{{< panel style="warning" >}}
Complete list of pregenerated alerts is available [here](https://github.com/monitoring-mixins/website/blob/master/assets/sealed-secrets/alerts.yaml).
{{< /panel >}}

### sealed-secrets

##### SealedSecretsUnsealErrorHigh

{{< code lang="yaml" >}}
alert: SealedSecretsUnsealErrorHigh
annotations:
  description: High number of errors during unsealing Sealed Secrets in {{ $labels.namespace
    }} namespace.
  runbook_url: https://github.com/bitnami-labs/sealed-secrets
  summary: Sealed Secrets Unseal Error High
expr: |
  sum by (reason, namespace) (rate(sealed_secrets_controller_unseal_errors_total{}[5m])) > 0
labels:
  severity: warning
{{< /code >}}
 
## Dashboards
Following dashboards are generated from mixins and hosted on github:


- [sealed-secrets-controller](https://github.com/monitoring-mixins/website/blob/master/assets/sealed-secrets/dashboards/sealed-secrets-controller.json)
