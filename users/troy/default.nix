{ inputs, pkgs, ... }:

{
  imports = [
    ./modules/alacritty.nix
    ./modules/bash.nix
    ./modules/git.nix
    ./modules/i3.nix
    ./modules/picom.nix
    ./modules/polybar.nix
    ./modules/rofi.nix
    ./modules/systemd.nix
    ./modules/vscode.nix
  ];

  home.homeDirectory = "/home/troy";
  home.username = "troy";

  # TODO: I don't need this if I set user packages?
  home.packages = with pkgs; [
    tldr

    nitrokey-app
    logseq
    dbeaver

    lazydocker

    google-chrome

    minecraft

    signal-desktop
    tdesktop
    whatsapp-for-linux
    skypeforlinux

    flameshot
    feh
    neofetch

    wireshark

    libnotify
    dunst
  ];

  home.sessionVariables = {
    EDITOR = "vim";
    BROWSER = "firefox";
  };

  home.stateVersion = "22.05";

  # Is it a problem I have a home service as well as a system service?
  services.gpg-agent = {
    enable = true;
    enableSshSupport = true;
    # What does the extra socket do?
    enableExtraSocket = true;
    sshKeys = [ "8ABF0116DA24246700017F956358D89FE8B148B8" ];
    pinentryFlavor = "gtk2";
    verbose = true;
  };

  programs.gpg = {
    enable = true;
    publicKeys = [
      {
        source = ../../keys/troy.pub.asc;
        trust = 5;
      }
      {
        source = ../../keys/inspiron.pub.asc;
        trust = 5;
      }
    ];
  };

  programs.home-manager.enable = true;

  programs.browserpass = {
    enable = true;
    browsers = [ "firefox" ];
  };
  programs.password-store.enable = true;

  programs.jq.enable = true;
  programs.direnv.enable = true;
  # I have never used this before, but it sounds useful.
  programs.direnv.nix-direnv.enable = true;

  # For when I switch to i3wm
  programs.alacritty.enable = true;
  programs.feh.enable = true;
  programs.zathura.enable = true;
  services.flameshot.enable = true;

  # There is a lot of configuration I can still set for these programs.
  programs.firefox = { enable = true; };
  programs.fzf.enable = true;
  # programs.powerline-go.enable = true;

  # Works with zsh, kitty, rofi, neovim, i3
  # programs.pywal.enable = true;

  # Give neovim a try?
  # programs.neovim.enable = true;

  # What does this do exactly?
  programs.command-not-found.enable = true;

  programs.lf.enable = true;

  programs.atuin.enable = true;

  programs.less.enable = true;
  programs.lesspipe.enable = true;

  # TODO: Maybe betterlockscreen should run upon startup of i3?
  services.betterlockscreen = {
    enable = true;
    arguments = [ "blur" ];
  };

  xdg = let
    # TODO: Change this into home.homeDirectory
    homeDir = "$HOME";
    mediaDir = "${homeDir}/Media";
  in {
    enable = true;
    userDirs = {
      enable = true;
      createDirectories = true;

      desktop = homeDir;
      documents = "${homeDir}/Documents";
      download = "${homeDir}/Downloads";
      music = mediaDir;
      pictures = mediaDir;
      publicShare = homeDir;
      templates = homeDir;
      videos = mediaDir;

      extraConfig = { XDG_PROJECTS_DIR = "${homeDir}/Projects"; };
    };
  };

  programs.dircolors.enable = true;

  # What does this do?
  targets.genericLinux.enable = true;

}
