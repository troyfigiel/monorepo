{ config, pkgs, ... }:

{
  home.username = "troy";
  home.homeDirectory = "/home/troy";

  home.packages = [
    pkgs.hello
  ];

  home.stateVersion = "22.05";

  programs.home-manager.enable = true;
  
  programs.bash = {
    enable = true;
    profileExtra = ''
      . ~/nix-files/profile
    '';
    bashrcExtra = ''
      . ~/nix-files/bashrc
    '';
    logoutExtra = ''
      . ~/nix-files/bash_logout
    '';
  };

  programs.git = {
    enable = true;
    userName = "Troy Figiel";
    userEmail = "troy.figiel@gmail.com";
    extraConfig = { 
      init = { defaultBranch = "main"; }; 
    };
  };
}
