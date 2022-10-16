MAKEFLAGS += --no-print-directory

MAKEFILE_DIR = $(patsubst %/,%,$(dir $(abspath $(lastword $(MAKEFILE_LIST)))))
MACHINE ?= $(file < /etc/hostname)

.PHONY: build deploy update upgrade terranix
all: deploy

deploy: terranix
	deploy $(MAKEFILE_DIR)#$(MACHINE)

build:
	sudo nixos-rebuild switch --flake $(MAKEFILE_DIR)#$(MACHINE)

update:
	nix flake update $(MAKEFILE_DIR)

upgrade:
	@$(MAKE) update
	@$(MAKE) build

terranix:
	nix build -o $(MAKEFILE_DIR)/infrastructure/config.tf.json
	terraform -chdir=$(MAKEFILE_DIR)/infrastructure init
	terraform -chdir=$(MAKEFILE_DIR)/infrastructure apply
	rm -f $(MAKEFILE_DIR)/infrastructure/config.tf.json
