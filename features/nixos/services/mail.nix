{ config, lib, pkgs, ... }:

with lib;
let cfg = config.features.services.mail;
in {
  imports = [ inputs.simple-nixos-mailserver.nixosModules.mailserver ];

  options.features.services.mail.enable =
    mkEnableOption "Enable the mail service.";

  config = let pqdn = "troyfigiel.com";
  in mkIf cfg.enable {
    sops.secrets.mail-troy-password = { };
    # TODO: I have not checked yet whether everything works.

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

