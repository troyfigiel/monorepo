{ inputs, pkgs, ... }:

rec {
  # TODO: Put back Emacs when I get homeConfigurations to work in my flake
  imports = [
    ./alacritty.nix
    ./dunst.nix
    ./git.nix
    ./i3.nix
    ./picom.nix
    ./polybar.nix
    ./rofi
    ./vscode.nix
    ./zsh
    ./smb.nix
    ./xdg.nix
  ];

  home = {
    # TODO: I have also had to define this in the users folder? Why?
    homeDirectory = "/home/troy";
    username = "troy";

    sessionVariables = {
      EDITOR = "vim";
      BROWSER = "firefox";
    };

    stateVersion = "22.05";
  };

  fonts.fontconfig.enable = true;

  # TODO: I don't need this if I set user packages?
  home.packages = with pkgs; [
    nmap

    thunderbird

    deploy-rs
    sops

    rclone
    fdupes

    hugo
    terraform

    # TODO: For now I will need to symlink a config in place
    # However, it would make more sense to create my own module for it.
    minio-client

    # TODO: Rofi-pass could be really nice, but needs some set up.
    # For example, it does not take my German keyboard into account.
    rofi-pass

    papirus-icon-theme

    font-awesome
    inconsolata

    tldr
    # Not sure about exa. I might as well put sane defaults on my ls aliases.
    # exa

    file
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
        source = ../../keys/ins.pub.asc;
        trust = 5;
      }
      {
        source = ../../keys/vtr.pub.asc;
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

  programs.direnv = {
    enable = true;
    nix-direnv.enable = true;
  };

  programs.alacritty.enable = true;
  programs.feh.enable = true;
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

  services.random-background = {
    enable = true;
    imageDirectory = "${home.homeDirectory}/.wallpapers";
  };

  programs.dircolors.enable = true;

  targets.genericLinux.enable = true;
}
