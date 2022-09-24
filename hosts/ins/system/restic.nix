{ config, ... }:

let
  backupUser = "pi";
  backupHost = "rpi";
in {
  services.restic.backups = {
    rpi-mnt = let backupLocation = "/home/pi/mnt/restic";
    in {
      repository = "sftp:${backupUser}@${backupHost}:${backupLocation}";
      initialize = true;
      passwordFile = config.sops.secrets.rpi-mnt-password.path;
      paths = [ "/nix/persist" ];
      timerConfig = {
        OnCalendar = "11:00";
      };
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
      timerConfig = {
        OnCalendar = "11:00";
      };
      extraOptions = [
        "sftp.command='ssh ${backupUser}@${backupHost} -i ${config.sops.secrets.ssh-restic.path} -s sftp'"
      ];
    };
  };
}
