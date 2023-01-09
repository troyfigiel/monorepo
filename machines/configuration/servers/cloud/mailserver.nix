# { inputs, ... }:

{
  # imports = [ inputs.simple-nixos-mailserver.nixosModules.mailserver ];

  # TODO: I have not checked yet whether everything works.
  # sops.secrets.mail-troy-password = { };
  # mailserver = {
  #   enable = true;
  #   fqdn = "mail.troyfigiel.com";
  #   domains = [ "troyfigiel.com" ];
  #   loginAccounts = {
  #     "troy@troyfigiel.com" = {
  #       hashedPasswordFile = config.sops.secrets.mail-troy-password.path;
  #     };
  #   };
  # };
}
