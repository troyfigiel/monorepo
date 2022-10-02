{ inputs, pkgs, ... }:

let homeDirectory = "/home/troy";
in {
  imports = [
    ./alacritty.nix
    ./dunst.nix
    ./emacs
    ./git.nix
    ./i3.nix
    ./picom.nix
    ./polybar.nix
    ./rofi
    ./syncthing.nix
    ./vscode.nix
    ./zsh
    ./smb.nix
    ./xdg.nix
  ];

  home = {
    inherit homeDirectory;
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

    restic

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
    zip
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

  # Give neovim a try?
  # programs.neovim.enable = true;

  # What does this do exactly?
  programs.command-not-found.enable = true;

  programs.lf.enable = true;

  programs.mpv.enable = true;

  programs.less.enable = true;
  programs.lesspipe.enable = true;

  # TODO: Maybe betterlockscreen should run upon startup of i3?
  # TODO: Can betterlockscreen run only when there is no video running?
  # If so, we can turn inactiveInterval down to 10 again.
  services.betterlockscreen = {
    enable = true;
    arguments = [ "blur" ];
    inactiveInterval = 60;
  };

  services.random-background = {
    enable = true;
    imageDirectory = "${homeDirectory}/.wallpapers";
  };

  programs.dircolors.enable = true;

  targets.genericLinux.enable = true;

  # This is necessary to auto-start services such as the bind mounts.
  systemd.user.startServices = "sd-switch";

  home.persistence."/nix/persist/home/troy" = {
    directories = [
      # TODO: Which directories do I even need here?
      ".mc"
      # Signal stores its data in the .config directory.
      # See: https://github.com/signalapp/Signal-Desktop/issues/4975
      ".config/Signal"
      ".config/whatsapp-for-linux"
      ".config/rclone"
      ".config/nix"
      ".cache/whatsapp-for-linux"
      ".cache/mozilla"
      ".cache/nix-index"
      ".mozilla/firefox"
      ".mozilla/extensions"
      ".wallpapers"
      ".steam"
      ".local/share/DBeaverData"
      ".local/share/direnv"
      ".local/share/godot"
      ".local/share/gvfs-metadata"
      ".local/share/nix"
      ".local/share/password-store"
      ".local/share/Steam"
      ".local/share/vulkan"
      "documents"
      "downloads"
      "projects"
    ];
    files = [ ".ssh/known_hosts" ];
    allowOther = true;
  };
}
