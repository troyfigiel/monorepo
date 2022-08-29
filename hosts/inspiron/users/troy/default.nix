{ inputs, pkgs, ... }:

{
  imports = [
    ./modules/alacritty
    ./modules/dunst
    ./modules/git
    ./modules/i3
    ./modules/picom
    ./modules/polybar
    ./modules/rofi
    ./modules/vscode
    ./modules/zsh
  ];

  home.homeDirectory = "/home/troy";
  home.username = "troy";

  fonts.fontconfig.enable = true;

  # TODO: I don't need this if I set user packages?
  home.packages = with pkgs; [
    nmap

    # TODO: Rofi-pass could be really nice, but needs some set up.
    # For example, it does not take my German keyboard into account.
    rofi-pass

    papirus-icon-theme

    font-awesome
    inconsolata

    tldr
    # Not sure about exa. I might as well put sane defaults on my ls aliases.
    # exa

    fd

    libreoffice
    # zip and rar files
    unzip
    unar

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

    awscli
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
        source = ./keys/troy.pub.asc;
        trust = 5;
      }
      {
        source = ./keys/inspiron.pub.asc;
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
  # For some reason Zathura fails to build now.
  # See: https://github.com/NixOS/nixpkgs/issues/187305
  programs.zathura.enable = true;
  services.flameshot.enable = true;

  # There is a lot of configuration I can still set for these programs.
  programs.firefox.enable = true;
  programs.fzf.enable = true;
  # programs.powerline-go.enable = true;

  # Works with zsh, kitty, rofi, neovim, i3
  # programs.pywal.enable = true;

  # Give neovim a try?
  # programs.neovim.enable = true;

  # What does this do exactly?
  programs.command-not-found.enable = true;

  programs.lf.enable = true;

  programs.mpv.enable = true;

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
  in {
    enable = true;
    userDirs = {
      enable = true;
      createDirectories = true;

      desktop = homeDir;
      documents = "${homeDir}/Documents";
      download = "${homeDir}/Downloads";
      music = homeDir;
      pictures = homeDir;
      publicShare = homeDir;
      templates = homeDir;
      videos = homeDir;

      extraConfig = {
        XDG_PROJECTS_DIR = "${homeDir}/Projects";
      };
    };
  };

  programs.dircolors.enable = true;

  # TODO: What does this do?
  targets.genericLinux.enable = true;
}
