{ impermanence, config, lib, pkgs, ... }:

with lib;
let cfg = config.features.qemu;
in {
  options.features.qemu.enable = mkEnableOption "qemu";

  config = mkIf cfg.enable (mkMerge [
    { virtualisation.libvirtd.enable = true; }

    (optionalAttrs impermanence {
      environment = {
        systemPackages = with pkgs; [ qemu virt-manager ];
        persistence."/nix/persist".directories = [ "/var/lib/libvirt" ];
      };
    })
  ]);
}
