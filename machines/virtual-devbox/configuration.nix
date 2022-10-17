{ inputs, config, pkgs, ... }:

{
  imports = [
    inputs.sops-nix.nixosModules.sops
    inputs.impermanence.nixosModules.impermanence
    inputs.simple-nixos-mailserver.nixosModules.mailserver
    inputs.home-manager.nixosModules.home-manager
    ../../features/nixos/docker.nix
    ../../features/nixos/locale.nix
    ../../features/nixos/nix.nix
    ../../features/nixos/qemu-guest.nix
    ../../features/nixos/system.nix
    ../../features/nixos/xorg.nix
  ];

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

  features = {
    docker.enable = true;
    locale.enable = true;
    nix.enable = true;
    qemu-guest.enable = true;
    # system.enable = true;
    # xorg = {
    #   enable = true;
    #   videoDrivers = [ "qxl" ];
    # };
  };

  users.users.troy = {
    initialPassword = "nixos";
    isNormalUser = true;
    shell = pkgs.zsh;
    extraGroups = [ "wheel" "docker" ];
    packages = with pkgs; [ vim git ];
  };

  system.stateVersion = "22.11";
}
