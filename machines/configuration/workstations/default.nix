{ config, lib, inputs, impermanence, pkgs, ... }:

let inherit (config.home-manager.users.troy) home;
in {
  imports = [ ./.. inputs.home-manager.nixosModules.home-manager ];

  programs.fuse.userAllowOther = true;

  time.timeZone = "Europe/Berlin";
  i18n.defaultLocale = "en_US.utf8";
  console.keyMap = "de";

  services.xserver = {
    enable = true;
    layout = "de";
    xkbOptions = "ctrl:nocaps";
    autoRepeatDelay = 300;
    autoRepeatInterval = 50;
    displayManager = {
      defaultSession = "none+i3";
      sddm = {
        enable = true;
        theme = "sugar-candy";
      };
    };
    desktopManager = {
      xterm.enable = false;
      xfce = {
        enable = true;
        noDesktop = true;
        enableXfwm = false;
      };
    };
    windowManager.i3.enable = true;
    libinput = {
      enable = true;
      touchpad.tapping = true;
    };
  };

  virtualisation.docker.enable = true;

  environment = {
    systemPackages = with pkgs; [
      brightnessctl
      inxi
      nix-index
      python3
      sddm-sugar-candy
    ];

    persistence."/nix/persist" = {
      directories = [
        "/etc/nixos"
        "/var/log"
        "/var/lib/docker"
        # This gets rid of the local sysadmin lecture message.
        # TODO: This could be symlinked in place, because it only requires a file with username to exist.
        {
          directory = "/var/db/sudo/lectured";
          mode = "0700";
        }
      ];
      files = [ "/etc/machine-id" ];
    };
  };

  users.users.troy = {
    isNormalUser = true;
    home = "/home/troy";
    description = "Troy Figiel";
    extraGroups = [ "wheel" "docker" ];
    uid = 1000;
  };

  home-manager = {
    useGlobalPkgs = true;
    useUserPackages = true;
    extraSpecialArgs = { inherit inputs impermanence; };
    users.troy = {
      imports = [ inputs.impermanence.nixosModules.home-manager.impermanence ];

      home = {
        username = "troy";
        homeDirectory = "/home/troy";
        stateVersion = "22.05";

        packages = with pkgs; [ emacs-all-the-icons-fonts inconsolata ];

        persistence."/nix/persist${home.homeDirectory}" = {
          directories = [
            ".cache/nix-index"
            ".config/nix"
            ".emacs.d/eln-cache"
            ".emacs.d/var"
            ".emacs.d/etc"
            ".local/share/direnv"
            ".local/share/nix"
            ".ssh"
            "documents"
            "downloads"
            "projects"
          ];
          allowOther = true;
        };
      };

      fonts.fontconfig.enable = true;

      programs = {
        # I need to explicity enable bash to have a working direnv integration outside of Emacs.
        bash.enable = true;

        dircolors.enable = true;

        direnv = {
          enable = true;
          nix-direnv.enable = true;
        };

        emacs = {
          enable = true;
          package = pkgs.tf-emacs;
        };

        git = {
          enable = true;
          userName = "Troy Figiel";
          userEmail = "troy.figiel@gmail.com";
          signing = { key = "E47C0DCD2768DFA138FCDCD6C67C9181B3893FB0"; };
          extraConfig = {
            init.defaultBranch = "main";
            rerere.enabled = true;
            commit.verbose = true;
            pull.rebase = true;
            push.autoSetupRemote = true;
          };
        };

        rofi = {
          enable = true;
          extraConfig = {
            modi = "drun,window";
            display-drun = "Applications:";
            display-window = "Windows:";
            font = "Inconsolata Medium 16";
            drun-display-format = "{icon} {name}";
            show-icons = true;
            icon-theme = "Papirus";
            kb-row-up = "Ctrl+p";
            kb-row-down = "Ctrl+n";
          };
          theme = ../../assets/dotfiles/rofi-theme.rasi;
        };
      };

      # TODO: Create a systemd service that checks the battery every minute
      # and sends a notification if the battery is low.
      services = {
        dunst = {
          enable = true;
          iconTheme = {
            # TODO: I should set some keybindings for dunstctl
            # TODO: How can I make the papirus icon theme monochrome?
            package = pkgs.papirus-icon-theme;
            name = "Papirus";
          };
          settings = {
            global = {
              width = 400;
              height = 300;
              offset = "10x20";
              origin = "top-right";

              frame_width = 2;
              frame_color = "#aaaaaa";
              transparency = 30;

              font = "Inconsolata 12";
              text_icon_padding = 20;
              markup = "full";
              format = ''
                <b>%s</b>
                %b'';
              alignment = "left";
              vertical_alignment = "center";
            };
            urgency_low = {
              background = "#11121D";
              foreground = "#FFFFFF";
              timeout = 10;
              new_icon = "bell";
            };
            urgency_normal = {
              background = "#11121D";
              foreground = "#FFFFFF";
              timeout = 10;
              new_icon = "bell";
            };
            urgency_critical = {
              background = "#FF8060";
              foreground = "#000000";
              timeout = 0;
            };
          };
        };
      };

      xdg = {
        enable = true;
        userDirs = {
          enable = true;
          createDirectories = false;

          desktop = home.homeDirectory;
          documents = "${home.homeDirectory}/documents";
          download = "${home.homeDirectory}/downloads";
          music = home.homeDirectory;
          pictures = home.homeDirectory;
          publicShare = home.homeDirectory;
          templates = home.homeDirectory;
          videos = home.homeDirectory;
          extraConfig = {
            XDG_PROJECTS_DIR = "${home.homeDirectory}/projects";
          };
        };
      };

      xsession = {
        enable = true;

        windowManager.i3 = {
          enable = true;
          package = pkgs.i3-gaps;

          config = let modifier = "Mod4";
          in {
            inherit modifier;
            bars = [ ];

            window.border = 2;

            gaps = {
              inner = 8;
              outer = -4;
              smartGaps = true;
              smartBorders = "on";
            };

            # TODO: Do not depend on the defaults.
            # I have too many keybindings here to know what is default and what is mine.
            keybindings = lib.mkOptionDefault {
              "${modifier}+h" = "focus left";
              "${modifier}+j" = "focus down";
              "${modifier}+k" = "focus up";
              "${modifier}+l" = "focus right";

              "${modifier}+a" = "focus parent";
              "${modifier}+d" = "focus child";

              "${modifier}+n" = "workspace next";
              "${modifier}+p" = "workspace prev";

              "${modifier}+v" = ''
                split vertical; exec ${pkgs.dunst}/bin/dunstify "i3" "Tiling vertically"
              '';
              "${modifier}+z" = ''
                split horizontal; exec ${pkgs.dunst}/bin/dunstify "i3" "Tiling horizontally"
              '';

              "${modifier}+Ctrl+h" = "move left";
              "${modifier}+Ctrl+j" = "move down";
              "${modifier}+Ctrl+k" = "move up";
              "${modifier}+Ctrl+l" = "move right";

              "${modifier}+Ctrl+n" = "move container to workspace next";
              "${modifier}+Ctrl+p" = "move container to workspace prev";

              "${modifier}+m" = "exec ${pkgs.rofi}/bin/rofi -show drun";
              "${modifier}+b" = "exec ${pkgs.rofi}/bin/rofi -show window";
              "${modifier}+i" = "exec ${pkgs.rofi-pass}/bin/rofi-pass";
              # "${modifier}+Shift+g" = "mode gaps";
              "${modifier}+q" = "kill";

              "${modifier}+Shift+q" =
                "exec ${pkgs.betterlockscreen}/bin/betterlockscreen";

              "XF86AudioMute" = ''
                exec ${pkgs.alsa-utils}/bin/amixer set Master toggle; exec ${pkgs.dunst}/bin/dunstify "Toggling mute"
              '';
              "XF86AudioLowerVolume" = ''
                exec ${pkgs.alsa-utils}/bin/amixer set Master 1%-; exec ${pkgs.dunst}/bin/dunstify "Decreasing volume"
              '';
              "XF86AudioRaiseVolume" = ''
                exec ${pkgs.alsa-utils}/bin/amixer set Master 1%+; exec ${pkgs.dunst}/bin/dunstify "Increasing volume"
              '';

              #"XF86AudioPause" = "exec ${pkgs.mpc-cli}/bin/mpc toggle";
              #"XF86AudioPrev" = "exec ${pkgs.mpc-cli}/bin/mpc prev";
              #"XF86AudioNext" = "exec ${pkgs.mpc-cli}/bin/mpc next";

              "XF86MonBrightnessDown" = ''
                exec ${pkgs.brightnessctl}/bin/brightnessctl set 3%-; exec ${pkgs.dunst}/bin/dunstify "Decreasing brightness"
              '';
              "XF86MonBrightnessUp" = ''
                exec ${pkgs.brightnessctl}/bin/brightnessctl set 3%+; exec ${pkgs.dunst}/bin/dunstify "Increasing brightness"
              '';
            };

            startup = [
              {
                command =
                  "${pkgs.feh}/bin/feh --bg-fill ${../../assets/nixos.jpg}";
                always = true;
                notification = false;
              }
              {
                command =
                  "${pkgs.betterlockscreen}/bin/betterlockscreen --update ${
                    ../../assets/nixos.jpg
                  }";
                always = true;
                notification = false;
              }
            ];
          };
        };
      };
    };
  };
}
