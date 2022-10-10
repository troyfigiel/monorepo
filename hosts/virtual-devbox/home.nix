{ inputs, pkgs, ... }:

let homeDirectory = "/home/troy";
in {
  home = {
    # inherit homeDirectory;
    username = "troy";

    sessionVariables = {
      EDITOR = "vim";
    };

    stateVersion = "22.05";
  };

  fonts.fontconfig.enable = true;

  programs.home-manager.enable = true;

  programs.direnv = {
    enable = true;
    nix-direnv.enable = true;
  };

  programs.fzf.enable = true;

  programs.dircolors.enable = true;

  localModules = {
    alacritty.enable = true;
    git = {
      enable = true;
      userEmail = "troy.figiel@gmail.com";
      lazygit.enable = true;
    };
    vscode.enable = true;
    xdg-no-persist.enable = true;
  };
}
