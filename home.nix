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
    firefox
    logseq
    vscode
    xclip
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
