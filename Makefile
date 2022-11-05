MAKEFLAGS += --no-print-directory

ROOT_DIR = $(patsubst %/,%,$(dir $(abspath $(lastword $(MAKEFILE_LIST)))))
MACHINE ?= $(file < /etc/hostname)

.PHONY: all
all:
	nix run .#terra
	$(MAKE) deploy

.PHONY: build
build:
	$(MAKE) checks
	sudo nixos-rebuild switch --flake "$(ROOT_DIR)#$(MACHINE)"

.PHONY: checks
checks:
	@nix fmt
	@nix run .#lint

.PHONY: deploy
deploy:
	$(MAKE) checks
	deploy $(ROOT_DIR)
