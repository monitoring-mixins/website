---
title: openldap
---

## Overview



{{< panel style="danger" >}}
Jsonnet source code is available at [github.com/grafana/jsonnet-libs](https://github.com/grafana/jsonnet-libs/tree/master/openldap-mixin)
{{< /panel >}}

## Alerts

{{< panel style="warning" >}}
Complete list of pregenerated alerts is available [here](https://github.com/monitoring-mixins/website/blob/master/assets/openldap/alerts.yaml).
{{< /panel >}}

### openldap-alerts

##### OpenLDAPConnectionSpike

{{< code lang="yaml" >}}
alert: OpenLDAPConnectionSpike
annotations:
  description: There are {{ printf "%.0f" $value }} OpenLDAP connections on instance
    {{$labels.instance}}, which is above the threshold of 100.
  summary: A sudden spike in OpenLDAP connections indicates potential high usage or
    security issues.
expr: |
  increase(openldap_monitor_counter_object{dn="cn=Current,cn=Connections,cn=Monitor"}[5m]) > 100
for: 5m
labels:
  severity: warning
{{< /code >}}
 
##### OpenLDAPHighSearchOperationRateSpike

{{< code lang="yaml" >}}
alert: OpenLDAPHighSearchOperationRateSpike
annotations:
  description: The rate of search operations in OpenLDAP on instance {{$labels.instance}}
    has increased by {{ printf "%.0f" $value }} percent in the last 5 minutes, compared
    to the average over the last 15 minutes, which is above the threshold of 200 percent.
  summary: A significant spike in OpenLDAP search operations indicates inefficient
    queries, potential abuse, or unintended heavy load.
expr: "100 * (
  rate(openldap_monitor_operation{dn=\"cn=Search,cn=Operations,cn=Monitor\"}[5m])
  
  / 
  clamp_min(rate(openldap_monitor_operation{dn=\"cn=Search,cn=Operations,cn=Monitor\"}[15m]
  offset 5m), 0.0001)
) > 200
"
for: 5m
labels:
  severity: warning
{{< /code >}}
 
##### OpenLDAPDialFailures

{{< code lang="yaml" >}}
alert: OpenLDAPDialFailures
annotations:
  description: LDAP dial failures on instance {{$labels.instance}} have increased
    by {{ printf "%.0f" $value }} in the last 10 minutes, which is above the threshold
    of 10.
  summary: Significant increase in LDAP dial failures indicates network issues, problems
    with the LDAP service, or configuration errors that may lead to service unavailability.
expr: |
  increase(openldap_dial{result!="ok"}[10m]) > 10
for: 10m
labels:
  severity: warning
{{< /code >}}
 
##### OpenLDAPBindFailureRateIncrease

{{< code lang="yaml" >}}
alert: OpenLDAPBindFailureRateIncrease
annotations:
  description: LDAP bind failures on instance {{$labels.instance}} have increased
    by {{ printf "%.0f" $value }} in the last 10 minutes, which is above the threshold
    of 10.
  summary: Significant increase in LDAP bind failures indicates authentication issues,
    potential security threats or problems with user directories.
expr: |
  increase(openldap_bind{result!="ok"}[10m]) > 10
for: 10m
labels:
  severity: warning
{{< /code >}}
 
## Dashboards
Following dashboards are generated from mixins and hosted on github:


- [*](https://github.com/monitoring-mixins/website/blob/master/assets/openldap/dashboards/*.json)
