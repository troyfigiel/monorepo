{ config, pkgs, ... }:

{
  imports = [
    ./home/bash.nix
    ./home/files.nix
    ./home/git.nix
    ./home/systemd.nix
    ./home/vscode.nix
  ];

  home.username = "troy";
  home.homeDirectory = "/home/troy";

  home.packages = with pkgs; [
    tldr

    nitrokey-app
    logseq
    dbeaver

    firefox
    google-chrome

    minecraft

    signal-desktop
    tdesktop
    whatsapp-for-linux
    skypeforlinux

    flameshot
  ];

  home.sessionVariables = {
    EDITOR = "vim";
    BROWSER = "firefox";
  };

  home.stateVersion = "22.05";

  # What does this do?
  targets.genericLinux.enable = true;

  programs.home-manager.enable = true;
}
