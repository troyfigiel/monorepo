{ impermanence, config, lib, pkgs, ... }:

with lib;
let cfg = config.features.xorg;
in {
  options.features.xorg = {
    enable = mkEnableOption "xorg";

    videoDrivers = mkOption { type = types.listOf types.str; };
  };

  config = mkIf cfg.enable {
    services.xserver = {
      enable = true;
      layout = "de";
      xkbVariant = "";

      autoRepeatDelay = 300;
      autoRepeatInterval = 50;

      # TODO: What does this do?
      videoDrivers = cfg.videoDrivers;

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
  };
}
