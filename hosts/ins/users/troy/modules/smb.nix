{
  # Temporarily turn off Share since the NAS is down.
  # config.xdg.userDirs.pubicShare = {
  #   device = "//nas/shared";
  #   fsType = "cifs";
  #   options = [
  #     # TODO: These credentials can be set with username= and password= using sops
  #     "credentials=/nix/persist/etc/nixos/smb-secrets"
  #     "x-systemd.automount"
  #     "noauto"
  #     "uid=1000"
  #     "gid=100"
  #   ];
  # };
}
