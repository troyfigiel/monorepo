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
    xclip

    nitrokey-app
    firefox
    logseq
    dbeaver

    google-chrome
    minecraft

    signal-desktop
    tdesktop
    whatsapp-for-linux
    skypeforlinux

    flameshot
    #sshfs
    #gpg2
    #pass
    #flameshot
    #pandoc
  ];

  home.sessionVariables = {
    EDITOR = "vim";
    BROWSER = "firefox";
  };

  home.sessionPath = [
    "$HOME/.local/bin"    
  ];

  home.stateVersion = "22.05";

  targets.genericLinux.enable = true;

  programs.home-manager.enable = true;
}
