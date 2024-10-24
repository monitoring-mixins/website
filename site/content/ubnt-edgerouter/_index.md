---
title: ubnt-edgerouter
---

## Overview



{{< panel style="danger" >}}
Jsonnet source code is available at [github.com/grafana/jsonnet-libs](https://github.com/grafana/jsonnet-libs/tree/master/ubnt-edgerouter-mixin)
{{< /panel >}}

## Recording rules

{{< panel style="warning" >}}
Complete list of pregenerated recording rules is available [here](https://github.com/monitoring-mixins/website/blob/master/assets/ubnt-edgerouter/rules.yaml).
{{< /panel >}}

### ubnt.rules

##### ifNiceName

{{< code lang="yaml" >}}
expr: label_join(ifAdminStatus,"nicename", ":", "ifName", "ifAlias")
record: ifNiceName
{{< /code >}}
 
## Dashboards
Following dashboards are generated from mixins and hosted on github:


- [ubnt-edgrouterx-overview](https://github.com/monitoring-mixins/website/blob/master/assets/ubnt-edgerouter/dashboards/ubnt-edgrouterx-overview.json)
