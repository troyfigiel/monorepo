{ pkgs, ... }:

{
  imports = [ ./hardware-configuration.nix ];

  networking.networkmanager.enable = true;

  environment.systemPackages = with pkgs; [ vim ];
  services = {
    openssh = {
      enable = true;
      passwordAuthentication = false;
      permitRootLogin = "yes";
    };
  };

  users.users.root.openssh.authorizedKeys.keys =
    [ (builtins.readFile ../../assets/keys/troy.pub.ssh) ];

  system.stateVersion = "23.05";
}
