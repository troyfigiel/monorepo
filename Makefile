MAKEFLAGS += --no-print-directory

ROOT_DIR = $(patsubst %/,%,$(dir $(abspath $(lastword $(MAKEFILE_LIST)))))
MACHINE ?= $(file < /etc/hostname)

.PHONY: all
all:
	$(MAKE) terranix
	$(MAKE) deploy

.PHONY: build
build:
	sudo nixos-rebuild switch --flake "$(ROOT_DIR)#$(MACHINE)"

.PHONY: deploy
deploy:
	deploy $(ROOT_DIR)

.PHONY: format
format:
	find $(ROOT_DIR) -name '*.nix' | xargs nixfmt

.PHONY: terranix
terranix:
	nix build -o $(ROOT_DIR)/machines/config.tf.json
	terraform -chdir=$(ROOT_DIR)/machines init
	terraform -chdir=$(ROOT_DIR)/machines apply
	rm -f $(ROOT_DIR)/machines/config.tf.json

.PHONY: update
update:
	if [ -z $(INPUT) ]; then \
		nix flake update $(ROOT_DIR); \
	else \
		nix flake lock --update-input $(INPUT) $(ROOT_DIR); \
	fi

.PHONY: upgrade
upgrade:
	$(MAKE) update
	$(MAKE) build

.PHONY: partitions
partitions:
	parted $(DISK) -- mklabel gpt && \
	parted $(DISK) -- mkpart ESP fat32 1MiB 512MiB && \
	parted $(DISK) -- set 1 boot on && \
	parted $(DISK) -- mkpart NIX ext4 512MiB 100\%

.PHONY: filesystems
filesystems:
	mkfs.vfat /dev/disk/by-partlabel/ESP && \
	mkfs.ext4 /dev/disk/by-partlabel/NIX

.PHONY: install
install:
	mount -t tmpfs none /mnt && \
	mkdir -p /mnt/{boot,nix,etc/nixos,var/log} && \
	mount /dev/disk/by-partlabel/ESP /mnt/boot && \
	mount /dev/disk/by-partlabel/NIX /mnt/nix && \
	mkdir -p /mnt/nix/persist/{reproducible-builds,var/log} && \
	mount -o bind /mnt/nix/persist/var/log /mnt/var/log && \
	cp -r $(ROOT_DIR)/. /mnt/nix/persist/reproducible-builds && \
	nixos-install --no-root-passwd --flake /mnt/nix/persist/reproducible-builds#$(MACHINE)

.PHONY: bootstrap
bootstrap:
	$(MAKE) partitions
	sleep 1
	$(MAKE) filesystems
	sleep 1
	$(MAKE) install
