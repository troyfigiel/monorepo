{ config, pkgs, ... }:

let inherit (config.home-manager.users.troy) home;
in {
  imports = [ ./.. ];

  environment.systemPackages = with pkgs; [ gnupg pinentry ];

  home-manager.users.troy = {
    home = {
      packages = with pkgs; [
        fdupes
        feh
        file
        firefox
        font-awesome
        libreoffice
        lzip
        mpv
        nitrokey-app
        papirus-icon-theme
        rofi-pass
        signal-desktop
        skypeforlinux
        sops
        tdesktop
        unar
        unzip
        zip
      ];

      persistence."/nix/persist${home.homeDirectory}" = {
        directories = [
          ".local/share/password-store"

          ".cache/mozilla"
          ".mozilla/firefox"
          ".mozilla/extensions"

          # Signal stores its data in the .config directory.
          # See: https://github.com/signalapp/Signal-Desktop/issues/4975
          ".config/Signal"

          # Telegram has a single directory in .local/share
          ".local/share/TelegramDesktop"
        ];
        allowOther = true;
      };
    };

    programs.password-store.enable = true;

    # TODO: This should be part of my workstation configuration, but on my VM picom does not seem
    # to work properly.
    services.picom = {
      enable = true;
      vSync = true;
    };

    # TODO: Maybe betterlockscreen should run upon startup of i3?
    # TODO: Can betterlockscreen run only when there is no video running?
    # If so, we can turn inactiveInterval down to 10 again.
    services.betterlockscreen = {
      enable = true;
      inactiveInterval = 60;
    };

    # Is it a problem I have a home service as well as a system service?
    services.gpg-agent = {
      enable = true;
      enableSshSupport = true;
      # What does the extra socket do?
      enableExtraSocket = true;
      sshKeys = [ "8ABF0116DA24246700017F956358D89FE8B148B8" ];
      pinentryFlavor = "gtk2";
      verbose = true;
    };

    programs.gpg = {
      enable = true;
      # TODO: This is currently stopping me from completely defining my host name in terms of the directory name.
      publicKeys = [
        {
          source = ../../../assets/admin-keys/troy.pub.asc;
          trust = 5;
        }
        {
          source = ./key.pub.asc;
          trust = 5;
        }
        {
          source = ../../servers/cloud/key.pub.asc;
          trust = 5;
        }
      ];
    };
  };

  services.blueman.enable = true;

  networking.networkmanager = {
    enable = true;
    plugins = [ pkgs.networkmanager-openvpn ];
  };

  # Trusting a bluetooth device is needed to automatically connect.
  environment.persistence."/nix/persist".directories = [
    "/var/lib/bluetooth"
    {
      directory = "/etc/NetworkManager";
      mode = "0755";
    }
  ];

  system.stateVersion = "22.05";

  services.xserver.videoDrivers = [ "modesetting" ];

  sops.secrets.troy-password = { neededForUsers = true; };

  # TODO: Should I set the group to be "troy" as well?
  users = {
    mutableUsers = false;
    users.troy = {
      extraGroups = [ "networkmanager" "libvirtd" ];
      passwordFile = config.sops.secrets.troy-password.path;
    };
  };

  environment.persistence."/nix/persist" = {
    hideMounts = true;
    users.root = {
      home = "/root";
      directories = [ ".gnupg" ".ssh" ];
    };
  };

  # sops.secrets = {
  #   ssh-restic = { };
  #   rpi-mnt-password = { };
  #   rpi-backup-password = { };
  # };

  # services.restic.backups = let
  #   backupUser = "pi";
  #   backupHost = "rpi";
  # in {
  #   rpi-mnt = let backupLocation = "/home/pi/mnt/restic";
  #   in {
  #     repository = "sftp:${backupUser}@${backupHost}:${backupLocation}";
  #     initialize = true;
  #     passwordFile = config.sops.secrets.rpi-mnt-password.path;
  #     paths = [ "/nix/persist" ];
  #     timerConfig = { OnCalendar = "11:00"; };
  #     extraOptions = [
  #       "sftp.command='ssh ${backupUser}@${backupHost} -i ${config.sops.secrets.ssh-restic.path} -s sftp'"
  #     ];
  #   };

  #   rpi-backup = let backupLocation = "/home/pi/backup/restic";
  #   in {
  #     repository = "sftp:${backupUser}@${backupHost}:${backupLocation}";
  #     initialize = true;
  #     passwordFile = config.sops.secrets.rpi-backup-password.path;
  #     paths = [ "/nix/persist" ];
  #     timerConfig = { OnCalendar = "11:00"; };
  #     extraOptions = [
  #       "sftp.command='ssh ${backupUser}@${backupHost} -i ${config.sops.secrets.ssh-restic.path} -s sftp'"
  #     ];
  #   };
  # };

  # TODO: This works, but need to check how to configure my printers declaratively in NixOS
  services.printing = {
    enable = true;
    drivers = [ pkgs.epson-escpr2 ];
  };

  # TODO: What does rtkit do?
  security.rtkit.enable = true;
  sound.enable = true;
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
  };

  services.avahi = {
    enable = true;
    nssmdns = true;
  };

  # virtualisation.libvirtd.enable = true;
  # environment = {
  #   systemPackages = with pkgs; [ qemu virt-manager ];
  #   persistence."/nix/persist".directories = [ "/var/lib/libvirt" ];
  # };
}
