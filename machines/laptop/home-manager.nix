{ config, hmModules, impermanence, inputs, pkgs, ... }:

{
  home-manager = {
    useGlobalPkgs = true;
    useUserPackages = true;
    extraSpecialArgs = { inherit inputs impermanence; };

    users = {
      troy = let cfg = config.home-manager.users.troy;
      in {
        imports = [
          inputs.impermanence.nixosModules.home-manager.impermanence
          hmModules.alacritty
          hmModules.background
          hmModules.dunst
          hmModules.emacs
          hmModules.firefox
          hmModules.git
          hmModules.gpg
          hmModules.i3
          hmModules.messenger
          hmModules.nvim
          hmModules.pass
          hmModules.picom
          hmModules.polybar
          hmModules.rofi
          hmModules.syncthing
          hmModules.vscode
          hmModules.xdg
          hmModules.zsh
        ];

        home = {
          username = "troy";
          homeDirectory = "/home/${cfg.home.username}";
          stateVersion = "22.05";
        };

        fonts.fontconfig.enable = true;

        # TODO: I don't need this if I set user packages?
        home.packages = with pkgs; [
          nmap
          restic
          deploy-rs
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
          inconsolata
          tldr
          file
          fd
          libreoffice
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

        programs.direnv = {
          enable = true;
          nix-direnv.enable = true;
        };

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

        programs.dircolors.enable = true;

        home.persistence."/nix/persist/${cfg.home.homeDirectory}" = {
          directories = [
            # TODO: Which directories do I even need here?
            ".mc"
            # Signal stores its data in the .config directory.
            # See: https://github.com/signalapp/Signal-Desktop/issues/4975
            ".config/rclone"
            ".config/nix"
            ".cache/nix-index"
            ".wallpapers"
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

        features = {
          alacritty.enable = true;

          background = {
            enable = true;
            wallpaperDirectory = "/nix/persist/home/troy/.wallpapers";
          };

          dunst.enable = true;

          firefox = {
            enable = true;
            defaultBrowser = true;
          };

          git.enable = true;
          gpg.enable = true;
          i3.enable = true;
          messenger.enable = true;
          pass.enable = true;
          picom.enable = true;
          polybar.enable = true;
          syncthing.enable = true;
          vscode.enable = true;
          xdg.enable = true;
          emacs.enable = true;
          rofi.enable = true;

          nvim = {
            enable = true;
            defaultEditor = true;
          };

          zsh.enable = true;
        };
      };
    };
  };
}
