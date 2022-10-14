{ impermanence, config, lib, pkgs, ... }:

with lib;
let cfg = config.roles.xorg;
in {
  options.roles.xorg.enable = mkEnableOption "xorg";

  config = mkIf cfg.enable {
    services.xserver = {
      enable = true;
      layout = "de";
      xkbVariant = "";

      autoRepeatDelay = 300;
      autoRepeatInterval = 50;

      videoDrivers = [ "modesetting" ];

      displayManager = {
        defaultSession = "none+i3";
        sddm = {
          enable = true;
          theme = "sugar-candy";
        };
      };

      desktopManager = {
        xterm.enable = false;

        cinnamon.enable = true;

        xfce = {
          enable = true;
          noDesktop = true;
          enableXfwm = false;
        };
      };

      windowManager.i3 = {
        enable = true;
        extraPackages = with pkgs; [ rofi polybar i3lock ];
      };

      libinput = {
        enable = true;
        touchpad.tapping = true;
      };
    };
  };
}
