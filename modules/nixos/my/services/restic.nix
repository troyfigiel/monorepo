{ config, lib, ... }:

with lib;
let
  cfg = config.my.restic;
  backupUser = "pi";
  backupHost = "rpi";

in {
  options.my.restic.enable = mkEnableOption "Restic";

  config = mkIf cfg.enable {
    sops.secrets = {
      ssh-restic = { };
      rpi-mnt-password = { };
      rpi-backup-password = { };
    };

    services.restic.backups = {
      rpi-mnt = let backupLocation = "/home/pi/mnt/restic";
      in {
        repository = "sftp:${backupUser}@${backupHost}:${backupLocation}";
        initialize = true;
        passwordFile = config.sops.secrets.rpi-mnt-password.path;
        paths = [ "/nix/persist" ];
        timerConfig = { OnCalendar = "11:00"; };
        extraOptions = [
          "sftp.command='ssh ${backupUser}@${backupHost} -i ${config.sops.secrets.ssh-restic.path} -s sftp'"
        ];
      };

      rpi-backup = let backupLocation = "/home/pi/backup/restic";
      in {
        repository = "sftp:${backupUser}@${backupHost}:${backupLocation}";
        initialize = true;
        passwordFile = config.sops.secrets.rpi-backup-password.path;
        paths = [ "/nix/persist" ];
        timerConfig = { OnCalendar = "11:00"; };
        extraOptions = [
          "sftp.command='ssh ${backupUser}@${backupHost} -i ${config.sops.secrets.ssh-restic.path} -s sftp'"
        ];
      };
    };
  };
}
