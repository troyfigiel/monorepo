{
  imports = [ ./.. ./nfs.nix ./samba.nix ];
  system.stateVersion = "23.05";
  networking = {
    networkmanager.enable = true;
    useDHCP = false;
  };
}
