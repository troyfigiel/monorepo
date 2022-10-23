{ inputs, nixosModules, pkgs, ... }:

{
  imports = [
    ./home-manager.nix
    inputs.sops-nix.nixosModules.sops
    inputs.impermanence.nixosModules.impermanence
    inputs.simple-nixos-mailserver.nixosModules.mailserver
    inputs.home-manager.nixosModules.home-manager
    nixosModules.docker
    nixosModules.locale
    nixosModules.nix
    nixosModules.system
    nixosModules.xorg
  ];

  features = {
    docker.enable = true;
    locale.enable = true;
    nix.enable = true;
    system.enable = true;
    xorg = {
      enable = true;
      # TODO: modesetting is necessary to even get i3 to run successfully. Otherwise no screens will be found. What does this do?
      # Modesetting fixed the issues I had with sddm and i3.
      # I do have some issues with the compositor still.
      videoDrivers = [ "modesetting" ]; # "qxl" ];
    };
  };

  users.users.troy = {
    initialPassword = "nixos";
    isNormalUser = true;
    shell = pkgs.zsh;
    extraGroups = [ "wheel" "docker" ];
    packages = with pkgs; [ git gnumake vim ];
  };

  programs.fuse.userAllowOther = true;

  system.stateVersion = "22.11";
}
