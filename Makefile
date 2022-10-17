MAKEFLAGS += --no-print-directory

MAKEFILE_DIR = $(patsubst %/,%,$(dir $(abspath $(lastword $(MAKEFILE_LIST)))))
MACHINE ?= $(file < /etc/hostname)

.PHONY: build deploy format terranix update upgrade
all: deploy

build:
	sudo nixos-rebuild switch --flake $(MAKEFILE_DIR)#$(MACHINE)

deploy: terranix
	deploy $(MAKEFILE_DIR)#$(MACHINE)

format:
	find $(MAKEFILE_DIR) -name '*.nix' | xargs nixfmt

terranix:
	nix build -o $(MAKEFILE_DIR)/infrastructure/config.tf.json
	terraform -chdir=$(MAKEFILE_DIR)/infrastructure init
	terraform -chdir=$(MAKEFILE_DIR)/infrastructure apply
	rm -f $(MAKEFILE_DIR)/infrastructure/config.tf.json

update:
	nix flake update $(MAKEFILE_DIR)

upgrade:
	@$(MAKE) update
	@$(MAKE) build
