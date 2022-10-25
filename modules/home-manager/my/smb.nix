{ config, lib, ... }:

with lib;
let cfg = config.my.smb;
in {
  options.my.smb.enable = mkEnableOption "smb";

  config.xdg.userDirs.publicShare = mkIf cfg.enable {
    device = "//nas/shared";
    fsType = "cifs";
    options = [
      # TODO: These credentials can be set with username= and password= using sops
      "credentials=/nix/persist/etc/nixos/smb-secrets"
      "x-systemd.automount"
      "noauto"
      "uid=1000"
      "gid=100"
    ];
  };
}
