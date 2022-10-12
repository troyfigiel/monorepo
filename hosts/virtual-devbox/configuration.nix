{ config, pkgs, ... }:

{
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

  environment.systemPackages = with pkgs; [ git python3 vim nixfmt ];

  nix = {
    package = pkgs.nixVersions.stable;
    settings.auto-optimise-store = true;

    gc = {
      automatic = true;
      dates = "weekly";
    };

    extraOptions = ''
      experimental-features = nix-command flakes
      min-free = ${toString (3 * 1024 * 1024 * 1024)}
      max-free = ${toString (10 * 1024 * 1024 * 1024)}
    '';
  };

  system.stateVersion = "22.11";
}
