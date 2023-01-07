{ config, ... }:

{
  sops.secrets.restic = { };
  services.restic.backups = let
    initialize = true;
    passwordFile = config.sops.secrets.restic.path;
    paths = let mountLocation = "/mnt/export";
    in [
      "${mountLocation}/gitea"
      "${mountLocation}/nfs"
      "${mountLocation}/smb"
    ];
  in {
    on-disk = {
      repository = "/mnt/export/restic";
      inherit initialize passwordFile paths;
    };
    backup-disk = {
      repository = "/mnt/backup/restic";
      inherit initialize passwordFile paths;
    };
  };
}
