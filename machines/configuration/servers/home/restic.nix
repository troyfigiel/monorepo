{ config, pkgs, ... }:

{
  sops.secrets = {
    local-restic = { };
    b2-restic = { };
    b2-environment = { };
  };

  environment.systemPackages = [ pkgs.restic ];

  services.restic.backups = let
    initialize = true;
    paths = let mountLocation = "/mnt/export";
    in [
      "${mountLocation}/gitea"
      "${mountLocation}/nfs"
      "${mountLocation}/smb"
    ];
  in {
    on-disk = {
      repository = "/mnt/export/restic";
      passwordFile = config.sops.secrets.local-restic.path;
      timerConfig = {
        OnCalendar = "01:00";
        RandomizedDelaySec = "30m";
      };
      inherit initialize paths;
    };
    backup-disk = {
      repository = "/mnt/backup/restic";
      passwordFile = config.sops.secrets.local-restic.path;
      timerConfig = {
        OnCalendar = "02:00";
        RandomizedDelaySec = "30m";
      };
      inherit initialize paths;
    };
    backblaze = {
      # TODO: The repository can be read from Terraform outputs.json.
      repository = "s3:s3.us-west-004.backblazeb2.com/troyfigiel-backup";
      passwordFile = config.sops.secrets.b2-restic.path;
      environmentFile = config.sops.secrets.b2-environment.path;
      timerConfig = {
        OnCalendar = "03:00";
        RandomizedDelaySec = "30m";
      };
      inherit initialize paths;
    };
  };
}
