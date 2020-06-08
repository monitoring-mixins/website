#!/bin/bash
#shellcheck disable=SC2129,SC2164
#set -euo pipefail

MANIFESTS="assets"
TOP=$(git rev-parse --show-toplevel)
TMPDIR="${TOP}/tmp"

download_mixin() {
	local mixin="$1"
	local repo="$2"
	local subdir="$3"

	git clone --depth 1 --filter=blob:none "$repo" "${TMPDIR}/$mixin"
	mkdir -p "${TOP}/${MANIFESTS}/${mixin}/dashboards"
	(
		cd "${TMPDIR}/${mixin}/${subdir}"
		if [ -f "jsonnetfile.json" ]; then
			jb install
		fi
	
		jsonnet -J vendor -S -e 'std.manifestYamlDoc((import "mixin.libsonnet").prometheusAlerts)' | gojsontoyaml > "${TOP}/${MANIFESTS}/${mixin}/alerts.yaml" || :
		jsonnet -J vendor -S -e 'std.manifestYamlDoc((import "mixin.libsonnet").prometheusRules)' | gojsontoyaml > "${TOP}/${MANIFESTS}/${mixin}/rules.yaml" || :
		jsonnet -J vendor -m "${TOP}/${MANIFESTS}/${mixin}/dashboards" -e '(import "mixin.libsonnet").grafanaDashboards' || :
	)
}

parse_rules() {
	local source="$1"
	local type="$2"
	for group in $(echo "$source" | jq -cr '.groups[].name'); do
		echo -e "### ${group}\n"
		for rule in $(echo "$source" | jq -cr ".groups[] | select(.name == \"${group}\") | .rules[] | @base64"); do
			var=$(echo "$rule" | base64 --decode | gojsontoyaml);
			name=$(echo -e "$var" | grep "$type" | awk -F ': ' '{print $2}')
			echo -e "##### ${name}\n"
			echo -e '{{< code lang="yaml" >}}'
			echo -e "$var"
			echo -e '{{< /code >}}\n '
		done
	done
}

panel() {
	echo -e "{{< panel style=\"$1\" >}}"
	echo -e "$2"
	echo -e "{{< /panel >}}\n"
}

mixin_header() {
	local name="$1"
	local repo="$2"
	local url="$3"
	local description="$4"

	cat << EOF
---
title: $name
---

## Overview

$description

EOF
panel "danger" "Jsonnet source code is available at [${repo#*//}]($url)"
}


cd "${TOP}" || exit 1
# remove generated assets and temporary directory
rm -rf "$MANIFESTS" "$TMPDIR"
# remove generated site content
find site/content/ ! -name '_index.md' -type f -exec rm -rf {} +

mkdir -p "${TMPDIR}"

# Generate mixins 
CONFIG=$(gojsontoyaml -yamltojson < mixins.yaml)

for mixin in $(echo "$CONFIG" | jq -r '.mixins[].name'); do
	repo="$(echo "$CONFIG" | jq -r ".mixins[] | select(.name == \"$mixin\") | .source")"
	subdir="$(echo "$CONFIG" | jq -r ".mixins[] | select(.name == \"$mixin\") | .subdir")"
	text="$(echo "$CONFIG" | jq -r ".mixins[] | select(.name == \"$mixin\") | .description")"
	if [ "$text" == "null" ]; then text=""; fi
	set +u
	download_mixin "$mixin" "$repo" "$subdir"
	#set -u

	mkdir -p "site/content/${mixin}"
	file="site/content/${mixin}/_index.md"
	# Create header
	if [ -n "$subdir" ]; then
		location="$repo/tree/master/$subdir"
	else
		location="$repo"
	fi
	mixin_header "$mixin" "$repo" "$location" "$text" > "$file"

	dir="$TOP/$MANIFESTS/$mixin"
	# Alerts
	if [ -s "$dir/alerts.yaml" ] && [ "$(stat -c%s "$dir/alerts.yaml")" -gt 20 ]; then
		echo -e "## Alerts\n" >> "$file"
		panel "warning" "Complete list of pregenerated alerts is available [here](https://github.com/monitoring-mixins/website/blob/master/$MANIFESTS/$mixin/alerts.yaml)." >> "$file"
		parse_rules "$(gojsontoyaml -yamltojson < "$dir/alerts.yaml")" "alert" >> "$file"
	fi

	# Recording Rules
	if [ -s "$dir/rules.yaml" ] && [ "$(stat -c%s "$dir/rules.yaml")" -gt 20 ]; then
		echo -e "## Recording rules\n" >> "$file"
		panel "warning" "Complete list of pregenerated recording rules is available [here](https://github.com/monitoring-mixins/website/blob/master/$MANIFESTS/$mixin/rules.yaml)." >> "$file"
		parse_rules "$(gojsontoyaml -yamltojson < "$dir/rules.yaml")" "record" >> "$file"
	fi

	# Dashboards
	if [ "$(ls -A "$dir/dashboards")" ]; then
		echo -e "## Dashboards\nFollowing dashboards are generated from mixins and hosted on github:\n\n" >> "$file"
		for dashboard in "$dir/dashboards"/*.json; do
			d="$(basename "$dashboard")"
			echo "- [${d%.*}](https://github.com/monitoring-mixins/website/blob/master/$MANIFESTS/$mixin/dashboards/$d)" >> "$file"
		done
	fi
done
