{ writeShellApplication, parted, util-linux, coreutils, gnused }:

writeShellApplication {
  name = "my-installer";
  runtimeInputs = [ parted util-linux coreutils gnused ];
  text = ''
    disk="$1"

    create_partitions () {
          parted "$1" -- mklabel gpt && \
          parted "$1" -- mkpart ESP fat32 1MiB 512MiB && \
          parted "$1" -- set 1 boot on && \
          parted "$1" -- mkpart NIX ext4 512MiB '100%'
    }

    create_filesystems () {
          mkfs.vfat /dev/disk/by-partlabel/ESP && \
          mkfs.ext4 /dev/disk/by-partlabel/NIX
    }

    mount_disk () {
          mount -t tmpfs none /mnt && \
          mkdir -p /mnt/{boot,nix,etc/nixos,var/log} && \
          mount /dev/disk/by-partlabel/ESP /mnt/boot && \
          mount /dev/disk/by-partlabel/NIX /mnt/nix && \
          mkdir -p /mnt/nix/persist/{etc/nixos,var/log} && \
          mount -o bind /mnt/nix/persist/etc/nixos /mnt/etc/nixos && \
          mount -o bind /mnt/nix/persist/var/log /mnt/var/log
    }

    install_nixos () {
          nixos-generate-config --root /mnt && \
          sed --in-place '/fsType = "tmpfs";/a \
            options = [ "defaults" "size=4G" "mode=755" ];' \
          /mnt/etc/nixos/hardware-configuration.nix && \
          sed --in-place '/system\.stateVersion = .*/a \
            users.users.root.initialPassword = "root";\n \
            environment.systemPackages = with pkgs; [ gnumake git vim ];' \
          /mnt/etc/nixos/configuration.nix && \
          nixos-install --no-root-passwd
    }

    create_partitions "$disk" && sleep 1
    create_filesystems
    mount_disk && sleep 1
    install_nixos
  '';
}
