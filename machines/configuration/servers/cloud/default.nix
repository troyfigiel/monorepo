{
  imports = [ ./.. ./fail2ban.nix ./mailserver.nix ./nginx.nix ];
  system.stateVersion = "22.05";
}
