# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

{ config, pkgs, ... }:

{
  imports =
    [ # Include the results of the hardware scan.
      ./hardware-configuration.nix
      ./modules/bootloader.nix
      ./modules/gpg.nix
      ./modules/graphics.nix
      ./modules/networking.nix
      ./modules/openvpn.nix
      ./modules/sound.nix
      ./modules/syncthing.nix
      ./modules/users.nix
      ./modules/xserver.nix
    ];


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
    # Debugging
    w3m
    sqlite

    # Python
    python3

    # Text editor
    vim

    # Environment
    syncthing
    direnv
    chezmoi

    # Essentials
    git
    wget
    xclip

    # Security
    gnupg
    pinentry
    pass
  ];

  # Some programs need SUID wrappers, can be configured further or are
  # started in user sessions.
  # programs.mtr.enable = true;

  # Allows communication with smartcards.
  services.pcscd.enable = true;  

  services.gnome.gnome-keyring.enable = pkgs.lib.mkForce false;

  # Flatpak
  services.flatpak.enable = true;

  xdg.portal.enable = true;
  xdg.portal.extraPortals = [ pkgs.xdg-desktop-portal-gtk ];

  virtualisation.docker.enable = true;

  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It‘s perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "22.05"; # Did you read the comment?

}
