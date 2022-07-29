{ config, pkgs, ... }:

{
  imports =
    [ ./home/bash.nix ./home/git.nix ./home/systemd.nix ./home/vscode.nix ];

  home.username = "troy";
  home.homeDirectory = "/home/troy";

  home.packages = with pkgs; [
    tldr

    nitrokey-app
    logseq
    dbeaver

    google-chrome

    # Steam runs into a "glXChooseVisual failed" error.
    # This probably has to do with my GPU set up.
    # steam
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

  # Is it a problem I have a home service as well as a system service?
  services.gpg-agent = {
    enable = true;
    enableSshSupport = true;
    sshKeys = [ "8ABF0116DA24246700017F956358D89FE8B148B8" ];
    pinentryFlavor = "gtk2";
    verbose = true;
  };

  programs.home-manager.enable = true;

  programs.password-store.enable = true;
  # autojump seems interesting, but how useful really?
  # programs.autojump.enable = true;

  programs.jq.enable = true;
  programs.direnv.enable = true;
  # I have never used this before, but it sounds useful.
  # programs.direnv.nix-direnv.enable = true;

  # For when I switch to i3wm
  # programs.feh.enable = true;
  # programs.zathura.enable = true;
  # services.flameshot.enable = true;

  # There is a lot of configuration I can still set for these programs.
  programs.firefox.enable = true;
  programs.fzf.enable = true;
  # programs.powerline-go.enable = true;

  # This seems interesting, but I need to understand it better.
  # programs.gitui.enable = true;

  # Works with zsh, kitty, rofi, neovim, i3
  programs.pywal.enable = true;

  # Give neovim a try?
  # programs.neovim.enable = true;

  # What does this do exactly?
  programs.command-not-found.enable = true;

  xdg = {
    enable = true;
    userDirs = {
      enable = true;
      createDirectories = true;
      # How can I use variables for this?
      music = "$HOME/Media";
      pictures = "$HOME/Media";
      publicShare = "$HOME";
      templates = "$HOME";
      videos = "$HOME/Media";
    };
    # I can also set desktopEntry instead of having to create them manually.
    # However, if I move over to i3wm, I might not need that anyway.
  };

  # My current set up with Pantheon does not seem to need dircolors, but a
  # different terminal might.
  # programs.dircolors.enable = true;

  # What does this do?
  targets.genericLinux.enable = true;
}
