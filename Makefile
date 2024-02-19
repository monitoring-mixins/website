SHELL=/bin/bash -o pipefail

BIN_DIR?=$(shell pwd)/tmp/bin

JB_BIN=$(BIN_DIR)/jb
GOJSONTOYAML_BIN=$(BIN_DIR)/gojsontoyaml
JSONNET_BIN=$(BIN_DIR)/jsonnet
TOOLING=$(JB_BIN) $(GOJSONTOYAML_BIN) $(JSONNET_BIN)

.PHONY: all
all: generate

.PHONY: generate
generate: $(JB_BIN) $(GOJSONTOYAML_BIN) $(JSONNET_BIN)
	cd hack && ./generate.sh

$(BIN_DIR):
	mkdir -p $(BIN_DIR)

$(TOOLING): $(BIN_DIR)
	@echo Installing tools from hack/tools.go
	@cd hack && go list -mod=mod -e -tags tools -f '{{ range .Imports }}{{ printf "%s\n" .}}{{end}}' ./ | xargs -tI % go build -mod=mod -o $(BIN_DIR) %
