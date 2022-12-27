{ pkgs, ... }:

{
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

  environment.systemPackages = with pkgs; [ sddm-sugar-candy ];
}
