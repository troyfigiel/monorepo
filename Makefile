MAKEFLAGS += --no-print-directory

ROOT_DIR = $(patsubst %/,%,$(dir $(abspath $(lastword $(MAKEFILE_LIST)))))
MACHINE ?= $(file < /etc/hostname)

.PHONY: all
all:
	$(MAKE) terranix
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
	mkdir -p /mnt/nix/persist/{etc/nixos,var/log} && \
	mount -o bind /mnt/nix/persist/etc/nixos /mnt/etc/nixos && \
	mount -o bind /mnt/nix/persist/var/log /mnt/var/log && \
	nixos-generate-config --root /mnt && \
	sed --in-place '/fsType = "tmpfs";/a \
		options = [ "defaults" "size=4G" "mode=755" ];' \
	/mnt/etc/nixos/hardware-configuration.nix && \
	sed --in-place '/system\.stateVersion = .*/a \
		users.users.root.initialPassword = "root";\n \
		environment.systemPackages = with pkgs; [ gnumake git vim ];' \
	/mnt/etc/nixos/configuration.nix && \
	nixos-install --no-root-passwd

.PHONY: bootstrap
bootstrap:
	$(MAKE) partitions
	sleep 1
	$(MAKE) filesystems
	sleep 1
	$(MAKE) install
