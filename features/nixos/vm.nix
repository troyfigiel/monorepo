{ impermanence, config, lib, pkgs, ... }:

with lib;
let cfg = config.features.vm;
in {
  options.features.vm.enable = mkEnableOption "vm";

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
