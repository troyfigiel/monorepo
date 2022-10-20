{ config, lib, ... }:

with lib;
let cfg = config.features.qemu-guest;
in {
  options.features.qemu-guest.enable = mkEnableOption "qemu-guest";

  config = mkIf cfg.enable {
    services.qemuGuest.enable = true;
    services.spice-vdagentd.enable = true;
  };
}
