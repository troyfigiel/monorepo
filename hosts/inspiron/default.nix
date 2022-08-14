{ config, pkgs, ... }:

let sshPath = "/nix/persist/etc/ssh";
in {
  imports = [ # Include the results of the hardware scan.
    ./hardware-configuration.nix
    ./modules/gpg.nix
    ./modules/graphics.nix
    ./modules/networking.nix
    ./modules/openvpn.nix
    ./modules/sound.nix
    ./modules/syncthing.nix
    ./modules/xserver.nix
    ./modules/impermanence.nix
  ];

  boot = {
    kernelPackages = pkgs.linuxPackages_latest;

    loader = {
      systemd-boot.enable = true;
      efi.canTouchEfiVariables = true;
      efi.efiSysMountPoint = "/boot/efi";
    };
  };

  # This is approximately how I should do an auto-upgrade, but the code here
  # probably does not work as-is.

  # system.autoUpgrade = {
  #   enable = true;
  #   allowReboot = true;
  #   # What is self.outPath?
  #   flake = self.outPath;
  #   # These are the flags going into nixos-rebuild
  #   flags = [
  #     "--recreate-lock-file"
  #     "--no-write-lock-file"
  #     "-L" # print build logs
  #   ];
  #   dates = "daily";
  #   # I might want to change the rebootWindow parameters.
  # };

  time.timeZone = "Europe/Berlin";
  i18n.defaultLocale = "en_US.utf8";
  console.keyMap = "de";

  environment.systemPackages = with pkgs;
    let sddm-sugar-candy = callPackage ../../pkgs/sddm-sugar-candy { };
    in [
      sddm-sugar-candy

      # Dependencies for sddm-sugar-candy
      libsForQt5.qt5.qtgraphicaleffects
      libsForQt5.qt5.qtquickcontrols2
      libsForQt5.qt5.qtsvg

      # Others
      nix-index
      git
      # htop
      bpytop
      python3
      sqlite

      vim
      w3m
      wget
      xclip
      nixfmt
      qemu

      # For i3 sshfs
      mpc-cli
      brightnessctl

      # Nicer form of du
      ncdu
    ];

  services.printing.enable = true;
  hardware.bluetooth = {
    enable = true;
    powerOnBoot = true;
  };

  services.openssh = {
    enable = true;
    passwordAuthentication = false;
    permitRootLogin = "no";

    hostKeys = [
      {
        bits = 4096;
        path = "${sshPath}/ssh_host_rsa_key";
        type = "rsa";
      }
      {
        path = "${sshPath}/ssh_host_ed25519_key";
        type = "ed25519";
      }
    ];
  };

  programs.nm-applet.enable = true;
  #services.mpd.enable = true;

  # TODO: How do I use Proton in Nix?
  programs.steam.enable = true;

  nix = {
    package = pkgs.nixFlakes;
    settings.auto-optimise-store = true;

    gc = {
      automatic = true;
      dates = "weekly";
    };

    extraOptions =
      pkgs.lib.optionalString (config.nix.package == pkgs.nixFlakes)
      "experimental-features = nix-command flakes";

    # TODO: Should I add an automatic garbage collection when I do not have enough space?
    # How much space should I free?
    # nix.extraOptions = ''
    #   min-free = ${toString (100 * 1024 * 1024)}
    #   max-free = ${toString (1024 * 1024 * 1024)}
    # '';
  };

  nixpkgs.config = { allowUnfree = true; };

  users = {
    mutableUsers = false;
    users.troy = {
      isNormalUser = true;
      home = "/home/troy";
      description = "Troy Figiel";
      # Why do I not need to set this?
      # shell = pkgs.bash;
      extraGroups = [ "networkmanager" "wheel" "docker" ];
      # I need to give the hashed version of my password with passwordFile,
      # because passwordFile is used directly in /etc/shadow. See:
      # https://nixos.org/manual/nixos/stable/options.html#opt-users.users._name_.passwordFile
      passwordFile = config.sops.secrets.troy-password.path;
    };
  };

  # TODO: By default the sudo password is the same password as my own password?
  # security.sudo = {
  #   enable = true;
  #   wheelNeedsPassword = true;
  #   execWheelOnly = true;
  # };

  sops = {
    defaultSopsFile = ./secrets.yaml;
    gnupg.sshKeyPaths = [ "${sshPath}/ssh_host_rsa_key" ];
    age.sshKeyPaths = [ ];

    secrets = {
      # Now I can access the secret with config.sops.secrets.troy-password.path
      troy-password = { neededForUsers = true; };
      work-vpn-username = { };
      work-vpn-password = { };
    };
  };

  virtualisation.docker.enable = true;

  system.stateVersion = "22.05";
}
