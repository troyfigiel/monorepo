{ config, lib, ... }:

with lib;
let cfg = config.my.mail;
in {
  options.my.mail.enable = mkEnableOption "Mail";

  config = mkIf cfg.enable {
    # TODO: I have not checked yet whether everything works.
    sops.secrets.mail-troy-password = { };

    mailserver = {
      enable = true;
      fqdn = "mail.troyfigiel.com";
      domains = [ "troyfigiel.com" ];

      loginAccounts = {
        "troy@troyfigiel.com" = {
          hashedPasswordFile = config.sops.secrets.mail-troy-password.path;
        };
      };
    };
  };
}
