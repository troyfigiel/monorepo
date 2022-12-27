{ config, inputs, lib, pkgs, ... }:

{
  imports = [
    ../../emacs/module.nix
    ../shared/docker.nix
    ../shared/dunst.nix
    ../shared/git.nix
    ../shared/home.nix
    ../shared/i3.nix
    ../shared/locale.nix
    ../shared/messenger.nix
    ../shared/nix.nix
    ../shared/pass.nix
    ../shared/picom.nix
    ../shared/rofi.nix
    ../shared/sops.nix
    ../shared/system.nix
    ../shared/xdg.nix
    ../shared/xorg.nix
    ./hardware-configuration.nix
    ./home-manager.nix
    inputs.home-manager.nixosModules.home-manager
  ];

  programs.fuse.userAllowOther = true;

  system.stateVersion = "22.05";

  services.xserver.videoDrivers = [ "modesetting" ];

  sops.secrets.troy-password = { neededForUsers = true; };

  # TODO: Should I set the group to be "troy" as well?
  users = {
    mutableUsers = false;

    users.troy = {
      isNormalUser = true;
      home = "/home/troy";
      description = "Troy Figiel";
      extraGroups = [ "networkmanager" "wheel" "docker" "libvirtd" ];
      passwordFile = config.sops.secrets.troy-password.path;
      # This is needed to be able to call deploy using my Nitrokey.
      openssh.authorizedKeys.keys =
        [ (builtins.readFile ../../assets/keys/troy.pub.ssh) ];
    };

    users.root = {
      openssh.authorizedKeys.keys =
        [ (builtins.readFile ../../assets/keys/troy.pub.ssh) ];
    };
  };

  environment.persistence."/nix/persist" = {
    hideMounts = true;
    users.root = {
      home = "/root";
      directories = [ ".gnupg" ];
      files = [ ".ssh/known_hosts" ];
    };
  };

  home-manager.users.troy = {
    home.packages = with pkgs; [
      nmap
      sops
      fdupes
      hugo
      # TODO: Rofi-pass could be really nice, but needs some set up.
      # For example, it does not take my German keyboard into account.
      rofi-pass
      papirus-icon-theme
      font-awesome
      file
      libreoffice
      lzip
      zip
      unzip
      unar
      nitrokey-app
      # TODO: This should be moved somewhere else. Parquet-tools can very easily read, show and transform parquet files.
      parquet-tools
    ];

    programs.feh.enable = true;
    services.flameshot.enable = true;

    # What does this do exactly?
    programs.command-not-found.enable = true;
    programs.mpv.enable = true;
    programs.less.enable = true;
    programs.lesspipe.enable = true;

    # TODO: Maybe betterlockscreen should run upon startup of i3?
    # TODO: Can betterlockscreen run only when there is no video running?
    # If so, we can turn inactiveInterval down to 10 again.
    services.betterlockscreen = {
      enable = true;
      inactiveInterval = 60;
    };

    home.persistence."/nix/persist/${config.home-manager.users.troy.home.homeDirectory}" =
      {
        directories = [
          ".config/nix"
          ".cache/nix-index"
          ".local/share/direnv"
          ".local/share/nix"
        ] ++ [ ".cache/mozilla" ".mozilla/firefox" ".mozilla/extensions" ];
        files = [ ".ssh/known_hosts" ];
        allowOther = true;
      };

    programs.firefox.enable = true;
    home.sessionVariables.BROWSER = "firefox";

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
          source = ../../assets/keys/troy.pub.asc;
          trust = 5;
        }
        {
          source = ../../hosts/laptop/key.pub.asc;
          trust = 5;
        }
        {
          source = ../../hosts/cloud-server/key.pub.asc;
          trust = 5;
        }
      ];
    };
  };

  sops.secrets = {
    ssh-restic = { };
    rpi-mnt-password = { };
    rpi-backup-password = { };
  };

  services.restic.backups = let
    backupUser = "pi";
    backupHost = "rpi";
  in {
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

  # TODO: This works, but need to check how to configure my printers declaratively in NixOS
  services.printing = {
    enable = true;
    drivers = [ pkgs.epson-escpr2 ];
  };

  services.blueman.enable = true;

  # Trusting a bluetooth device is needed to automatically connect.
  environment.persistence."/nix/persist".directories = [
    "/var/lib/bluetooth"
    {
      directory = "/etc/NetworkManager";
      mode = "0755";
    }
  ];

  # TODO: What does rtkit do?
  security.rtkit.enable = true;
  sound.enable = true;
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
  };

  # TODO: Either keep or remove this
  # services.mpd.enable = true;

  environment.systemPackages = with pkgs; [ gnupg pinentry ];

  # TODO: Allows communication with smartcards. Do I need this still?
  services.pcscd.enable = true;

  # TODO: Can I move this to the home config like I did with the gpg-agent?
  programs.ssh.startAgent = false;

  # TODO: Do I need this?
  services.gnome.gnome-keyring.enable = pkgs.lib.mkForce false;

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

  networking.networkmanager = {
    enable = true;
    plugins = [ pkgs.networkmanager-openvpn ];
  };

  programs.nm-applet.enable = true;
}
