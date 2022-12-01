{ config, lib, ... }:

with lib;
let cfg = config.my.locale;
in {
  options.my.locale.enable = mkEnableOption "locale";

  config = mkIf cfg.enable {
    time.timeZone = "Europe/Berlin";
    i18n.defaultLocale = "en_US.utf8";
    console.keyMap = "de";
  };
}
