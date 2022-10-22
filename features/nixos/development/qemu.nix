{ impermanence, config, lib, pkgs, ... }:

with lib;
let cfg = config.features.development.qemu;
in {
  options.features.development.qemu = {
    host.enable = mkEnableOption "QEMU hosting";
    guest.enable = mkEnableOption "QEMU guest";
  };

  config = (mkMerge [
    (mkIf cfg.host.enable (mkMerge [
      { virtualisation.libvirtd.enable = true; }

      (optionalAttrs impermanence {
        environment = {
          systemPackages = with pkgs; [ qemu virt-manager ];
          persistence."/nix/persist".directories = [ "/var/lib/libvirt" ];
        };
      })
    ]))

    (mkIf cfg.guest.enable {
      services.qemuGuest.enable = true;
      services.spice-vdagentd.enable = true;
    })
  ]);
}
