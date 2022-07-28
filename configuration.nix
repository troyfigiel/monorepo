{ config, pkgs, ... }:

{
  imports = [ # Include the results of the hardware scan.
    ./hardware-configuration.nix
    ./system/gpg.nix
    ./system/graphics.nix
    ./system/networking.nix
    ./system/openvpn.nix
    ./system/sound.nix
    ./system/syncthing.nix
    ./system/users.nix
    ./system/xserver.nix
  ];

  boot.loader = {
    systemd-boot.enable = true;
    efi.canTouchEfiVariables = true;
    efi.efiSysMountPoint = "/boot/efi";
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

  environment.systemPackages = with pkgs; [
    git
    htop
    python3
    sqlite
    sshfs
    vim
    w3m
    wget
    xclip
    nixfmt
  ];

  services.printing.enable = true;
  hardware.bluetooth.enable = true;

  nix = {
    package = pkgs.nixFlakes;
    extraOptions =
      pkgs.lib.optionalString (config.nix.package == pkgs.nixFlakes)
      "experimental-features = nix-command flakes";
  };

  nixpkgs.config = { allowUnfree = true; };

  virtualisation.docker.enable = true;

  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It‘s perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "22.05"; # Did you read the comment?
}
