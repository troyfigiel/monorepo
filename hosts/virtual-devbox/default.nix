{ config, pkgs, ... }:

{
  imports = [ ./hardware-configuration.nix ];

  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  networking.hostName = "virtual-devbox"; # Define your hostname.

  time.timeZone = "Europe/Berlin";
  i18n.defaultLocale = "en_US.UTF-8";

  services.xserver = {
    enable = true;
    displayManager = {
      gdm.enable = true;
      autoLogin = {
        enable = true;
        user = "troy";
      };
    };
    desktopManager.gnome.enable = true;
    layout = "de";
    libinput.enable = true;
    videoDrivers = [ "qxl" ];
  };

  services.qemuGuest.enable = true;
  services.spice-vdagentd.enable = true;

  virtualisation.docker.enable = true;

  users.users.troy = {
    initialPassword = "nixos";
    isNormalUser = true;
    extraGroups = [ "wheel" "docker" ];
    packages = with pkgs; [ vim git ];
  };

  system.stateVersion = "22.11";
}
