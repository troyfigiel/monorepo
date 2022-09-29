{ pkgs, ...}:

{
  services.nginx.virtualHosts."troyfigiel.com" = {
    forceSSL = true;
    enableACME = true;
    serverAliases = [ "www.troyfigiel.com" ];
    locations."/" = { root = pkgs.troyfigiel-com; };
  };
}
