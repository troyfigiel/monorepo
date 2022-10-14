{ config, lib, pkgs, ... }:

with lib;
let cfg = config.roles.printing;
in {
  options.roles.printing.enable = mkEnableOption "Printing";

  config = mkIf cfg.enable {
    # TODO: This works, but need to check how to configure my printers declaratively in NixOS
    services.printing = {
      enable = true;
      drivers = [ pkgs.epson-escpr2 ];
    };
  };
}
