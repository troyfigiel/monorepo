{ impermanence, config, lib, pkgs, ... }:

with lib;
let cfg = config.features.network.networking;
in {
  options.features.network.networking = {
    enable = mkEnableOption "Enable networking configuration.";
    printing.enable =
      mkEnableOption "Enable printing service for my Epson printer.";
    restic.enable = mkEnableOption "Enable backup service using Restic.";
  };

  config = mkIf cfg.enable (mkMerge [
    {
      networking.networkmanager = {
        enable = true;
        plugins = [ pkgs.networkmanager-openvpn ];
      };

      programs.nm-applet.enable = true;

      networking = {
        extraHosts = ''
          192.168.178.31 rpi
          192.168.178.37 nas
        '';
        useDHCP = lib.mkDefault true;
      };

      services.avahi = {
        enable = true;
        nssmdns = true;
      };
    }

    (mkIf cfg.enable && cfg.printing.enable {
      # TODO: This works, but need to check how to configure my printers declaratively in NixOS
      services.printing = {
        enable = true;
        drivers = [ pkgs.epson-escpr2 ];
      };
    })

    (mkIf cfg.enable && cfg.restic.enable {
      sops.secrets = {
        ssh-restic = { };
        rpi-mnt-password = { };
        rpi-backup-password = { };
      };

      services.restic.backups = let
        backupUser = "pi";
        backupHost = "rpi";
      in {
        rpi-mnt = let backupLocation = "/home/${backupUser}/mnt/restic";
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

        rpi-backup = let backupLocation = "/home/${backupUser}/backup/restic";
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
    })

    (optionalAttrs impermanence {
      environment.persistence."/nix/persist".directories = [{
        directory = "/etc/NetworkManager";
        mode = "0755";
      }];
    })
  ]);
}
