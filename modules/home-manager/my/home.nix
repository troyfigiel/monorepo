{ config, lib, pkgs, ... }:

with lib;
let cfg = config.my.home;
in {
  options.my.home = {
    enable = mkEnableOption "Home";
    # TODO: This is a temporary option to refactor my home-manager config.
    # It should be replaced by options that more clearly describe what they do.
    onLaptop = mkOption {
      default = false;
      type = types.bool;
    };
  };

  config = mkIf cfg.enable (mkMerge [
    {
      home = {
        username = "troy";
        homeDirectory = "/home/${config.home.username}";
        stateVersion = "22.05";
      };

      fonts.fontconfig.enable = true;

      programs.home-manager.enable = true;
      programs.direnv = {
        enable = true;
        nix-direnv.enable = true;
      };
      programs.dircolors.enable = true;
    }

    (mkIf cfg.onLaptop {
      home.packages = with pkgs; [
        nmap
        restic
        sops
        rclone
        fdupes
        hugo
        # TODO: For now I will need to symlink a config in place
        # However, it would make more sense to create my own module for it.
        minio-client
        # TODO: Rofi-pass could be really nice, but needs some set up.
        # For example, it does not take my German keyboard into account.
        rofi-pass
        papirus-icon-theme
        font-awesome
        tldr
        file
        fd
        libreoffice
        lzip
        zip
        unzip
        unar
        nitrokey-app
        dbeaver
        flameshot
        feh
        neofetch
        wireshark
      ];

      programs.jq.enable = true;
      programs.feh.enable = true;
      programs.zathura.enable = true;
      services.flameshot.enable = true;

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

      home.persistence."/nix/persist/${config.home.homeDirectory}" = {
        directories = [
          # TODO: Which directories do I even need here?
          ".mc"
          # Signal stores its data in the .config directory.
          # See: https://github.com/signalapp/Signal-Desktop/issues/4975
          ".config/rclone"
          ".config/nix"
          ".cache/nix-index"
          ".steam"
          ".local/share/DBeaverData"
          ".local/share/direnv"
          ".local/share/godot"
          ".local/share/gvfs-metadata"
          ".local/share/nix"
          ".local/share/Steam"
          ".local/share/vulkan"
        ];
        files = [ ".ssh/known_hosts" ];
        allowOther = true;
      };
    })
  ]);
}
