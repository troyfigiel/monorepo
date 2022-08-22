{ pkgs, ... }:

{
  networking.networkmanager = {
    enable = true;
    plugins = [ pkgs.networkmanager-openvpn ];
  };

  programs.nm-applet.enable = true;

  environment.persistence."/nix/persist".directories = [{
    directory = "/etc/NetworkManager";
    mode = "0755";
  }];
}
