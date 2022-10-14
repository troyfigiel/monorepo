{ config, lib, ... }:

with lib;
let cfg = config.roles.locale;
in {
  options.roles.locale.enable = mkEnableOption "locale";

  config = mkIf cfg.enable {
    time.timeZone = "Europe/Berlin";
    i18n.defaultLocale = "en_US.utf8";
    console.keyMap = "de";
  };
}
