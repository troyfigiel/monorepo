{ pkgs, ... }:

{
  services.xserver = {
    enable = true;
    layout = "de";
    xkbVariant = "";
    xkbOptions = "caps:escape";

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
}
