{ pkgs, ... }:

{
  networking = {
    hostName = "inspiron";
    extraHosts = "192.168.178.31 raspberry";
    networkmanager = {
      enable = true;
      plugins = [ pkgs.networkmanager-openvpn ];
    };
  };
}
