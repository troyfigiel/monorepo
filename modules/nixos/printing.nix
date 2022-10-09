{ config, lib, pkgs, ... }:

let
  cfg = config.localModules.printing;
  inherit (lib) mkEnableOption mkIf;
in {
  options.localModules.printing.enable = mkEnableOption "Printing";

  config = mkIf cfg.enable {
    # TODO: This works, but need to check how to configure my printers declaratively in NixOS
    services.printing = {
      enable = true;
      drivers = [ pkgs.epson-escpr2 ];
    };
  };
}
