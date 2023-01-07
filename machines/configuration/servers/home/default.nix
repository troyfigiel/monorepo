{
  imports = [ ./.. ./gitea.nix ./nfs.nix ./restic.nix ./samba.nix ];
  system.stateVersion = "23.05";
  networking.networkmanager.enable = true;
}
