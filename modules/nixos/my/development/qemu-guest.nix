{ config, lib, pkgs, ... }:

with lib;
let cfg = config.my.qemu-guest;
in {
  options.my.qemu-guest.enable = mkEnableOption "qemu-guest";

  config = mkIf cfg.enable {
    services.qemuGuest.enable = true;
    # TODO: For some reason it does not seem to work on UTM on MacOS. Why?
    services.spice-vdagentd.enable = true;
  };
}
