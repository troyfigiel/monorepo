{ pkgs, ... }:

{
  imports = [ ../shared/server.nix ./hardware-configuration.nix ];

  networking.networkmanager.enable = true;

  # Adding this is necessary to connect to nfs. Otherwise the firewall blocks the request.
  networking.firewall.allowedTCPPorts = [ 2049 ];
  networking.firewall.enable = true;

  environment.systemPackages = with pkgs; [ vim ];
  services = {
    openssh = {
      enable = true;
      passwordAuthentication = false;
    };

    nfs.server = {
      enable = true;
      exports = ''
        /export/nfs 192.168.178.26(rw,sync,no_subtree_check)
      '';
    };
  };
  system.stateVersion = "23.05";
}
