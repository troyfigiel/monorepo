{ config, pkgs, ... }:

let sshPath = "/etc/ssh";
in {
  imports = [ # Include the results of the hardware scan.
    ./hardware-configuration.nix
    ./modules/gpg.nix
    ./modules/graphics.nix
    ./modules/networking.nix
    ./modules/openvpn.nix
    ./modules/sound.nix
    ./modules/syncthing.nix
    ./modules/users.nix
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
  hardware.bluetooth.enable = true;

  services.openssh = {
    enable = true;
    # Harden
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

  sops.defaultSopsFile = ./secrets.yaml;

  # sops.gnupg.home = "/root/.gnupg";
  sops.gnupg.sshKeyPaths = [ "${sshPath}/ssh_host_rsa_key" ];
  sops.age.sshKeyPaths = [ ];

  # sops.secrets.troy-password = { neededForUsers = true; };
  sops.secrets.work-vpn-username = { };
  sops.secrets.work-vpn-password = { };
  # Now I can access the secret with config.sops.secrets.troy-password.path
  # I should set up the VPN after I switch away from Pantheon as my desktop environment.

  virtualisation.docker.enable = true;

  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It‘s perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "22.05"; # Did you read the comment?
}
