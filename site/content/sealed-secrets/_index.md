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

##### SealedSecretsUnsealErrorRateHigh

{{< code lang="yaml" >}}
alert: SealedSecretsUnsealErrorRateHigh
annotations:
  message: High rate of errors unsealing Sealed Secrets
  runbook: https://github.com/bitnami-labs/sealed-secrets
expr: |
  sum(rate(sealed_secrets_controller_unseal_errors_total{}[5m])) > 0
labels:
  severity: warning
{{< /code >}}
 
## Dashboards
Following dashboards are generated from mixins and hosted on github:


- [sealed-secrets-controller](https://github.com/monitoring-mixins/website/blob/master/assets/sealed-secrets/dashboards/sealed-secrets-controller.json)
