# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

{ config, pkgs, ... }:

{
  imports =
    [ # Include the results of the hardware scan.
      ./hardware-configuration.nix
      ./system/gpg.nix
      ./system/graphics.nix
      ./system/networking.nix
      # OpenVPN keeps asking for my username and
      # password whenever I run nixos-rebuild switch
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

  # Set your time zone.
  time.timeZone = "Europe/Berlin";

  # Select internationalisation properties.
  i18n.defaultLocale = "en_US.utf8";

  # Configure console keymap
  console.keyMap = "de";

  # Enable CUPS to print documents.
  services.printing.enable = true;

  # Enable sound with pipewire.

  # Enable Bluetooth support
  hardware.bluetooth.enable = true;

  nix = {
    package = pkgs.nixFlakes;
    extraOptions = pkgs.lib.optionalString (config.nix.package == pkgs.nixFlakes)
      "experimental-features = nix-command flakes";
  };

  nixpkgs.config = {
    allowUnfree = true;
  }; 
  
  environment.systemPackages = with pkgs; [
    git
    htop
    python3
    sqlite
    vim
    w3m
    wget
  ];

  # Some programs need SUID wrappers, can be configured further or are
  # started in user sessions.
  # programs.mtr.enable = true;

  virtualisation.docker.enable = true;

  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It‘s perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "22.05"; # Did you read the comment?

}
